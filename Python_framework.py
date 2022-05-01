

# Import the Client from ambf_comm package
# You might have to do: pip install gym
from ambf_client import Client
import pandas as pd
import time
from mat4py import loadmat

# Create a instance of the client
_client = Client()

# Connect the client which in turn creates callable objects from ROS topics
# and initiates a shared pool of threads for bi-directional communication
_client.connect()

# You can print the names of objects found
print(_client.get_obj_names())

# Lets say from the list of printed names, we want to get the
# handle to an object named "Torus"
obj = _client.get_obj_handle('baselink')
time.sleep(3)
obj.set_pos(0.5,0.5,0.5)
time.sleep(3)


tar = _client.get_obj_handle('target_ik')
time.sleep(3)
tar.set_pos(.1,.2,0)
time.sleep(.1)
tar.set_pos(.1,.5,0)
time.sleep(.1)
tar.set_pos(0.5,.2,0)
time.sleep(3)

# Load the Transformation Matrix positions
# If we have the entire T then 
# p = [T(1,4), T(2,4), T(3,4)];

# Next we import the data points as a list from the CSV file
# pip install pandas and then import

# Setting limit for rows that will show as part of the data file
# and reading the data sets
col_list = ["Point1_X","Point1_Y","Point1_Z","Point2_X","Point2_Y","Point2_Z","Point3_X","Point3_Y", "Point3_Z"]
df = pd.read_csv('davinci wrist sample.csv', usecols=col_list)

# Store the XYZ values of each point in 1 List , size is nx3 matrix
#Create 3 lists for 3 points 
# I think we will only be using tool tip list as of now

#Multiply the 1,2,3 column with p vector
# Multiply with a scaling factor
# Hint: Choose the Scaling factor such that the point comes under 2m example 200*x <=  2

# then create a loop that iterates over the list and set pos to (x,y,z)
#time.sleep (0.2 )... (2 KB left)
