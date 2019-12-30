import greengrasssdk
import platform
from threading import Timer
import time
import os
from botocore.session import Session
import boto3


# Creating a greengrass core sdk client
client = greengrasssdk.client('iot-data')

class PhotoDoesNotMeetRequirementError(Exception): pass

# Handler that gets triggered once something is posted on the testing/face_detection_edge/trigger topic
def function_handler(event, context):
    client.publish(topic='testing/face_detection_cloud', payload='Starting function: Uploading image from the Edge.')
    
    # Key             Value
    # -----------------------------
    # image_name      1_happy_face.jpg
    # image_path      /images
    # bucket_name     wildrydes-step-module-resource-riderphotos3bucket-tcokckkr6psc

    # Getting env vars
    image_path = os.environ['image_path']
    image_name = os.environ['image_name']
    bucket_name = os.environ['bucket_name']

    try:
        s3 = boto3.resource('s3')
        client.publish(topic='testing/face_detection_cloud', payload='Starting to upload image to the cloud')
        s3.meta.client.upload_file(image_path + '/' + image_name, bucket_name, image_name)
        client.publish(topic='testing/face_detection_cloud', payload='Done uploading image to the cloud')

    except Exception, e:
        client.publish(topic='testing/face_detection_cloud', payload='Exception: {} '.format(e))
        
    time.sleep(20)
    return
