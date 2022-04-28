#!/usr/bin/env python
import rospy
import numpy as np
from std_msgs.msg import Float64MultiArray

def callback(data):
    matrix=np.array([data.data[0:4],data.data[4:8],data.data[8:12],data.data[12:16]])
    matrix=np.transpose(matrix)	
    rospy.loginfo(matrix)

def listener():
    
       # In ROS, nodes are uniquely named. If two nodes with the same
       # name are launched, the previous one is kicked off. The
       # anonymous=True flag means that rospy will choose a unique
       # name for our 'listener' node so that multiple listeners can
       # run simultaneously.
    rospy.init_node('listener', anonymous=True)
  
    rospy.Subscriber("TransMatrix", Float64MultiArray, callback)
   
      # spin() simply keeps python from exiting until this node is stopped
    rospy.spin()
   
if __name__ == '__main__':
    listener()