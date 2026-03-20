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
                {'use_sim_time': True},
                {'min_distance': 0.3},
                {'distance_hysteresis': 0.08},
                {'forward_speed': 0.12},
                {'rotate_speed': 0.35},
                {'control_rate_hz': 10.0},
            ],
            output='screen',
        ),
    ])
