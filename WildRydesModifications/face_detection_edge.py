import greengrasssdk
import platform
from threading import Timer
import time
import os
from botocore.session import Session
import boto3
import dlib


# Creating a greengrass core sdk client
client = greengrasssdk.client('iot-data')

class PhotoDoesNotMeetRequirementError(Exception): pass


# Handler that gets triggered once something is posted on the testing/face_detection_cloud/trigger topic
def function_handler(event, context):
    client.publish(topic='testing/face_detection_edge', payload='Starting function: face detection on the Edge.')

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
        # Run dlib face detection
        detector = dlib.get_frontal_face_detector()
        img = dlib.load_rgb_image(image_path + '/' + image_name)
        dets = detector(img, 0)
        client.publish(topic='testing/face_detection_edge', payload='Found faces: {}'.format(len(dets)))

        if len(dets) == 0:
            raise PhotoDoesNotMeetRequirementError('No face deteced in the image')
        if len(dets) > 1:
            raise PhotoDoesNotMeetRequirementError('Multiple faces detected')

        # If there is one face, then upload image to s3
        s3 = boto3.resource('s3')
        client.publish(topic='testing/face_detection_cloud', payload='Starting to upload image to the cloud')
        s3.meta.client.upload_file(image_path + '/' + image_name, bucket_name, image_name)
        client.publish(topic='testing/face_detection_edge', payload='Done uploading image to the cloud')

    except Exception, e:
        client.publish(topic='testing/face_detection_edge', payload='Exception: {} '.format(e))
        
    time.sleep(20)
    return
