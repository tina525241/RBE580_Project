

# Import the Client from ambf_comm package
# You might have to do: pip install gym
from ambf_client import Client
import time
import rospy
#import numpy as np
from std_msgs.msg import Float64MultiArray

x=0
y=0
z=0
def callback(data):
    global x
    global y
    global z
    #matrix=np.array(data.data[12:16])
    xscaling=0.001
    yscaling=0.002
    zscaling=0.0003
    
    x=data.data[12]*xscaling
    y=data.data[13]*yscaling
    z=data.data[14]*zscaling

    #matrix=np.transpose(matrix)	
    rospy.loginfo(x)
    rospy.loginfo(y)
    rospy.loginfo(z)

def get_matrix():
    
    rospy.Subscriber("TransMatrix", Float64MultiArray, callback)
    
    time.sleep(3)
    tar = _client.get_obj_handle('toollink')
    tar.set_pos(x,y,z)
    time.sleep(.1)
    time.sleep(3)
   
      # spin() simply keeps python from exiting until this node is stopped
    rospy.spin()
   


if __name__ == '__main__':
# Create a instance of the client
    st=0
    _client = Client()

    # Connect the client which in turn creates callable objects from ROS topics
    # and initiates a shared pool of threads for bi-directional communication
    _client.connect()
    _client.print_active_topics()

    # You can print the names of objects found

    print(_client.get_obj_names())
    obj = _client.get_obj_handle('baselink')
    time.sleep(3)
    obj.set_pos(0,0,0)
    
    get_matrix()
    '''
    while(1):
        tar = _client.get_obj_handle('toolgripper1link')
        time.sleep(3)
        tar.set_pos(x,y,z)
        time.sleep(.1)
# Lets say from the list of printed names, we want to get the
# handle to an object named "Torus"

obj = _client.get_obj_handle('baselink')
time.sleep(3)
obj.set_pos(0.5,0.5,0.5)
time.sleep(3)


tar = _client.get_obj_handle('toollink')
time.sleep(3)
tar.set_pos(.1,.2,0)
time.sleep(.1)
tar.set_pos(.1,.1,0)
time.sleep(.1)
tar.set_pos(0.1,.2,0)
time.sleep(3)
'''