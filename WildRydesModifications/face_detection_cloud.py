import sys
import dlib
import boto3
import os
from botocore.exceptions import ClientError

s3 = boto3.resource('s3')

class PhotoDoesNotMeetRequirementError(Exception): pass

def handler(event, context):
    # Get bucket name and the name of the image
    source_bucket = event.get('s3Bucket') or None
    src_key = event.get('s3Key') or None

    # Initialize bucket and object
    bucket = s3.Bucket(source_bucket)
    obj = bucket.Object(src_key)
        
    # Download image from s3 bucket into tmp folder 
    with open('/tmp/image.jpg', 'wb') as data:
        obj.download_fileobj(data)

    # Run face detection
    detector = dlib.get_frontal_face_detector()
    img = dlib.load_rgb_image('/tmp/image.jpg')
    dets = detector(img, 0)
    
    if len(dets) == 0:
        raise PhotoDoesNotMeetRequirementError('No face deteced in the image')
    if len(dets) > 1:
        raise PhotoDoesNotMeetRequirementError('Multiple faces detected')
    # If we reach here then there is one face in the image and the function ran successfully





