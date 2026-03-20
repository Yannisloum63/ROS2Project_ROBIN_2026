# TurtleBot3 Burger ROS2 simulation launch file template
# Place this in your launch folder or adapt for your simulator

from launch import LaunchDescription
from launch_ros.actions import Node
from launch.actions import DeclareLaunchArgument
from launch.substitutions import LaunchConfiguration


def generate_launch_description():
    """
    Launch TurtleBot3 Burger simulation.
    Requires:
    - Gazebo installed
    - TurtleBot3 packages installed
    - Source: source /opt/ros/humble/setup.bash
    """
    
    return LaunchDescription([
        DeclareLaunchArgument(
            'use_sim_time',
            default_value='true',
            description='Use simulation (Gazebo) clock'
        ),
        
        # Example: Launch your TurtleBot3 world in Gazebo
        # This is a placeholder - adapt to your Gazebo launch file
        Node(
            package='gazebo_ros',
            executable='spawn_entity.py',
            name='spawn_turtlebot3',
            output='screen',
            parameters=[
                {'use_sim_time': LaunchConfiguration('use_sim_time')},
            ]
        ),
    ])
