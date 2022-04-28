# RBE580_Project
 Control daVinci Robot via Motion Capture
 
## Instruction
### Matlab
1. Install python2.7 and add to PATH ([tutorial](https://datascience.com.co/how-to-install-python-2-7-and-3-6-in-windows-10-add-python-path-281e7eae62a))
2. Type `pyenv('Version','2.7')` in Matlab

### Connect to ROS
#### Virtual Machine
1. Setting the "Bridged Adapter" mode in the VirtualBox Network Settings ([Detail](https://www.mathworks.com/matlabcentral/answers/392422-cannot-connect-to-ros-master-running-on-virtual-machine))
2. Connect to host computer ([Tutorial](https://rachelhson.wordpress.com/2020/05/03/ros-in-window-matlab-how-to-connect-virtual-machine/))
3. Change `ROS_MASTER_URI` in matlab script(line 14)

#### PC
1. `echo $ROS_MASTER_URI` in ubuntu terminal
2. Change it in matlab script(line 14)

## Subscriber example
1. `test_sub.py` is an example subscriber to subscrib the transformation matrix.
