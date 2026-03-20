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
                {'use_sim_time': True},
                {'cell_size': 0.5},
                {'coverage_threshold': 50},
                {'goal_tolerance': 0.25},
                {'publish_period_sec': 0.5},
            ],
            output='screen',
        ),
    ])
