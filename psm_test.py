# Import the Client from ambf_comm package
# You might have to do: pip install gym
from ambf_client import Client
import time
import rospy
#import numpy as np
from std_msgs.msg import Float64MultiArray

#x=0
#y=0
#z=0
tar=None
grip1=None
grip2=None

def wrist(data):
    #global x
    #global y
    #global z
    global tar
    #matrix=np.array(data.data[12:16])
    xscaling=0.0001
    yscaling=0.005
    zscaling=0.00003
    
    x=data.data[12]*xscaling
    y=data.data[13]*yscaling
    z=data.data[14]*zscaling
    rospy.loginfo("\nWrist:")
    rospy.loginfo(x)
    rospy.loginfo(y)
    rospy.loginfo(z)
    
    tar.set_pos(x,y,z)


def grip_1(data):
    
    global grip1
    #matrix=np.array(data.data[12:16])
    xscaling=0.00001
    yscaling=0.002
    zscaling=0.000003
    
    x1=data.data[12]*xscaling
    y1=data.data[13]*yscaling
    z1=data.data[14]*zscaling
    rospy.loginfo("\ngrip1:")
    rospy.loginfo(x1)
    rospy.loginfo(y1)
    rospy.loginfo(z1)
    
    grip1.set_pos(x1,y1,z1)


def grip_2(data):
    
    global grip2
    #matrix=np.array(data.data[12:16])
    xscaling=0.00001
    yscaling=0.002
    zscaling=0.000003
    
    x2=data.data[12]*xscaling
    y2=data.data[13]*yscaling
    z2=data.data[14]*zscaling
    rospy.loginfo("\ngrip2:")
    rospy.loginfo(x2)
    rospy.loginfo(y2)
    rospy.loginfo(z2)
    
    grip2.set_pos(x2,y2,z2)

def get_matrix():
    
    rospy.Subscriber("TransMatrix", Float64MultiArray, wrist)
    rospy.Subscriber("TransMatrix_grip1", Float64MultiArray, grip_1)
    rospy.Subscriber("TransMatrix_grip2", Float64MultiArray, grip_2)
    rospy.spin()
   


if __name__ == '__main__':
    # Create a instance of the client
   
    _client = Client()

    # Connect the client which in turn creates callable objects from ROS topics
    # and initiates a shared pool of threads for bi-directional communication
    _client.connect()
    _client.print_active_topics()

    # You can print the names of objects found

    print(_client.get_obj_names())
    obj = _client.get_obj_handle('baselink')
    time.sleep(1)
    obj.set_pos(0,0,1)
    #obj.set_rpy(0,0,1)
    arm = _client.get_obj_handle('yawlink')
    #arm = _client.get_obj_handle('toolrolllink')
    #arm.set_rpy(0,0,0.5)
    
    #arm = _client.get_obj_handle('maininsertionlink')
    arm.set_rpy(0,0,0.5)
    
    tar = _client.get_obj_handle('toolpitchlink')
    time.sleep(1)
    grip1 = _client.get_obj_handle('toolgripper1link')
    time.sleep(1)
    grip2 = _client.get_obj_handle('toolgripper2link')
    time.sleep(1)
    get_matrix()
  