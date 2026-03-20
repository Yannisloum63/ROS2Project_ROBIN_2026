from launch import LaunchDescription
from launch_ros.actions import Node


def generate_launch_description():
    """
    Launch the reactive avoidance node.
    """
    return LaunchDescription([
        Node(
            package='reactive_avoidance',
            executable='avoidance_node',
            name='avoidance_node',
            parameters=[
                {'min_distance': 0.3},
                {'forward_speed': 0.2},
                {'rotate_speed': 0.5},
            ],
            output='screen',
        ),
    ])
