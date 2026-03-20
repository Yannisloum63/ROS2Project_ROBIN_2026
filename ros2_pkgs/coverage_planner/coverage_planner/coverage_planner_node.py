#!/usr/bin/env python3
"""
Coverage Planner Node (Chapter 9-10)

This node generates a lawnmower/boustrophedon coverage pattern over a map
and sends sequential goals to Nav2 to ensure complete area coverage.

Subscribes:
  - /map (nav_msgs/OccupancyGrid) : static map
  - /amcl_pose (geometry_msgs/PoseWithCovarianceStamped) : robot localization

Publishes:
  - /goal_pose (geometry_msgs/PoseStamped) : goals for Nav2
"""

import rclpy
from rclpy.node import Node
from nav_msgs.msg import OccupancyGrid
from geometry_msgs.msg import PoseStamped, Point, Quaternion
from tf_transformations import quaternion_from_euler
import numpy as np
import math


class CoveragePlannerNode(Node):
    def __init__(self):
        super().__init__('coverage_planner_node')
        
        # Declare parameters
        self.declare_parameter('cell_size', 0.5)  # Size of grid cells in meters
        self.declare_parameter('coverage_threshold', 50)  # Occupancy threshold for free space
        
        self.cell_size = self.get_parameter('cell_size').value
        self.coverage_threshold = self.get_parameter('coverage_threshold').value
        
        # Map data
        self.map_data = None
        self.map_info = None
        self.coverage_goals = []
        self.visited_cells = set()
        
        # Subscribe to map
        self.map_subscriber = self.create_subscription(
            OccupancyGrid,
            '/map',
            self.map_callback,
            10
        )
        
        # Publisher for goals
        self.goal_publisher = self.create_publisher(
            PoseStamped,
            '/goal_pose',
            10
        )
        
        self.get_logger().info(f"Coverage planner initialized. Cell size: {self.cell_size}m")

    def map_callback(self, msg: OccupancyGrid):
        """
        Process occupancy grid and generate coverage path.
        """
        self.map_data = msg.data
        self.map_info = msg.info
        
        self.get_logger().info(f"Map received: {msg.info.width}x{msg.info.height}")
        
        # Generate lawnmower pattern
        self.generate_lawnmower_pattern()

    def generate_lawnmower_pattern(self):
        """
        Generate a lawnmower (boustrophedon) coverage pattern.
        """
        if self.map_data is None or self.map_info is None:
            return
        
        width = self.map_info.width
        height = self.map_info.height
        resolution = self.map_info.resolution
        origin = self.map_info.origin
        
        # Calculate cell size in grid units
        cell_size_grid = int(self.cell_size / resolution)
        if cell_size_grid < 1:
            cell_size_grid = 1
        
        # Generate waypoints in lawnmower pattern
        self.coverage_goals = []
        
        for y in range(0, height, cell_size_grid):
            if (y // cell_size_grid) % 2 == 0:
                # Even rows: left to right
                x_range = range(0, width, cell_size_grid)
            else:
                # Odd rows: right to left (for efficiency)
                x_range = range(width - cell_size_grid, -1, -cell_size_grid)
            
            for x in x_range:
                cell_idx = y * width + x
                
                # Check if cell is in free space
                if 0 <= cell_idx < len(self.map_data) and self.map_data[cell_idx] < self.coverage_threshold:
                    # Convert grid coords to world coords
                    world_x = origin.position.x + x * resolution
                    world_y = origin.position.y + y * resolution
                    
                    self.coverage_goals.append((world_x, world_y))
        
        self.get_logger().info(f"Generated {len(self.coverage_goals)} coverage waypoints")

    def publish_next_goal(self):
        """
        Publish the next coverage goal.
        """
        if not self.coverage_goals:
            self.get_logger().warn("No coverage goals available")
            return
        
        goal_x, goal_y = self.coverage_goals[0]
        
        # Create goal pose (facing forward, z=0)
        goal = PoseStamped()
        goal.header.frame_id = 'map'
        goal.header.stamp = self.get_clock().now().to_msg()
        
        goal.pose.position = Point(x=goal_x, y=goal_y, z=0.0)
        
        # Neutral orientation (facing x-axis)
        quat = quaternion_from_euler(0, 0, 0)
        goal.pose.orientation = Quaternion(
            x=float(quat[0]), y=float(quat[1]),
            z=float(quat[2]), w=float(quat[3])
        )
        
        self.goal_publisher.publish(goal)
        self.get_logger().info(f"Published goal: ({goal_x:.2f}, {goal_y:.2f})")
        
        # Remove published goal
        self.coverage_goals.pop(0)


def main(args=None):
    rclpy.init(args=args)
    node = CoveragePlannerNode()
    
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()


if __name__ == '__main__':
    main()
