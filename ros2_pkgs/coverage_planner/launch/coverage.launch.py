from launch import LaunchDescription
from launch_ros.actions import Node


def generate_launch_description():
    """
    Launch the coverage planner node.
    """
    return LaunchDescription([
        Node(
            package='coverage_planner',
            executable='coverage_planner_node',
            name='coverage_planner_node',
            parameters=[
                {'cell_size': 0.5},
                {'coverage_threshold': 50},
            ],
            output='screen',
        ),
    ])
