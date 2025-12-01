import json
import boto3
import logging
from botocore.exceptions import ClientError

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

EC2_CLIENT = boto3.client('ec2')
RDS_CLIENT = boto3.client('rds')

def lambda_handler(event, context):
    """
    Lambda function to stop EC2 instances and RDS databases when budget alerts are triggered
    """
    results = {
        'stopped_ec2_instances': [],
        'stopped_rds_instances': [],
        'errors': []
    }
    
    try:
        # Parse SNS message
        if 'Records' in event:
            for record in event['Records']:
                if record.get('EventSource') == 'aws:sns':
                    message = json.loads(record['Sns']['Message'])
                    logger.info(f"Received budget alert: {message}")
        
        # Stop all running EC2 instances
        logger.info("Checking for running EC2 instances...")
        try:
            response = EC2_CLIENT.describe_instances(
                Filters=[
                    {'Name': 'instance-state-name', 'Values': ['running']}
                ]
            )
            
            instance_ids = []
            for reservation in response['Reservations']:
                for instance in reservation['Instances']:
                    instance_ids.append(instance['InstanceId'])
            
            if instance_ids:
                logger.info(f"Stopping EC2 instances: {instance_ids}")
                EC2_CLIENT.stop_instances(InstanceIds=instance_ids)
                results['stopped_ec2_instances'] = instance_ids
            else:
                logger.info("No running EC2 instances found")
                
        except ClientError as e:
            error_msg = f"Error stopping EC2 instances: {str(e)}"
            logger.error(error_msg)
            results['errors'].append(error_msg)
        
        # Stop all available RDS instances (excluding clusters)
        logger.info("Checking for available RDS instances...")
        try:
            response = RDS_CLIENT.describe_db_instances()
            
            for db_instance in response['DBInstances']:
                if db_instance['DBInstanceStatus'] == 'available':
                    db_identifier = db_instance['DBInstanceIdentifier']
                    
                    # Skip if it's part of a cluster (Aurora)
                    if 'DBClusterIdentifier' not in db_instance:
                        logger.info(f"Stopping RDS instance: {db_identifier}")
                        RDS_CLIENT.stop_db_instance(DBInstanceIdentifier=db_identifier)
                        results['stopped_rds_instances'].append(db_identifier)
                    else:
                        logger.info(f"Skipping Aurora cluster member: {db_identifier}")
            
            if not results['stopped_rds_instances']:
                logger.info("No available RDS instances found to stop")
                
        except ClientError as e:
            error_msg = f"Error stopping RDS instances: {str(e)}"
            logger.error(error_msg)
            results['errors'].append(error_msg)
        
        logger.info(f"Automation results: {results}")
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Budget alert automation completed',
                'results': results
            })
        }
        
    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': 'Internal server error',
                'message': str(e)
            })
        }