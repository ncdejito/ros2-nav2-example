
docker run -it --net=host --device /dev/dri/ -e DISPLAY=$DISPLAY -v $HOME/.Xauthority:/root/.Xauthority:ro osrf/ros:humble-desktop

# install nav2
sudo apt install ros-<ros2-distro>-navigation2
sudo apt install ros-<ros2-distro>-nav2-bringup

cd ~
mkdir -p ros2_ws/src
cd ros2_ws/src
git clone https://github.com/ncdejito/ros2-nav2-example

# copy models folder ~5mins
docker ps
docker cp ~/Downloads/ros2-nav2-example/models 5b42f38b0747:root/ros2_ws/src/ros2-nav2-example

mv ros2-nav2-example two_wheeled_robot
cd ~/ros2_ws

# install deps
sudo apt install ros-humble-robot-localization
sudo apt install ros-humble-xacro
sudo apt install vim

vim ~/ros2_ws/src/two_wheeled_robot/CMakeLists.txt
# remove include/ and src/

# switch to cyclone dds
sudo apt install ros-humble-rmw-cyclonedds-cpp
echo "export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp" >> ~/.bashrc


# build package
colcon build --symlink-install
. install/setup.bash

# source setup scripts
vim ~/.bashrc
source /opt/ros/humble/setup.bash
. /root/ros2_ws/install/setup.bash

# launch world ~5mins
ros2 launch two_wheeled_robot office_world_v1.launch.py

# run delivery order
docker exec -it 5b42f38b0747 /bin/bash
cd ~/ros2_ws
cd src/two_wheeled_robot/scripts/
chmod +x pick_and_deliver.py 
cd ~/ros2_ws
ros2 run two_wheeled_robot pick_and_deliver.py
