#!/usr/bin/env python3
"""
Reactive Obstacle Avoidance Node (Chapter 7-8)

This node implements a simple reactive avoidance behavior:
- Subscribe to /scan (LaserScan)
- Check distance to nearest obstacle in front
- If too close: rotate in place
- Otherwise: move forward

Topics:
  - /scan (sensor_msgs/LaserScan) : input
  - /cmd_vel (geometry_msgs/Twist) : output
"""

import rclpy
from rclpy.node import Node
from sensor_msgs.msg import LaserScan
from geometry_msgs.msg import Twist
import math

class ReactiveAvoidanceNode(Node):
    def __init__(self):
        super().__init__('reactive_avoidance_node')
        
        # Declare parameters
        self.declare_parameter('min_distance', 0.3)
        self.declare_parameter('forward_speed', 0.2)
        self.declare_parameter('rotate_speed', 0.5)
        
        # Get parameters
        self.min_distance = self.get_parameter('min_distance').value
        self.forward_speed = self.get_parameter('forward_speed').value
        self.rotate_speed = self.get_parameter('rotate_speed').value
        
        # Create subscribers and publishers
        self.scan_subscriber = self.create_subscription(
            LaserScan,
            '/scan',
            self.scan_callback,
            10
        )
        
        self.cmd_vel_publisher = self.create_publisher(
            Twist,
            '/cmd_vel',
            10
        )
        
        self.get_logger().info(f"Reactive avoidance initialized. Min distance: {self.min_distance}m")

    def scan_callback(self, msg: LaserScan):
        """
        Process LaserScan and decide action.
        """
        # Get front distance (ignore inf and nan values)
        front_distance = float('inf')
        
        # Calculate front index (straight ahead)
        num_ranges = len(msg.ranges)
        front_idx = num_ranges // 2
        
        # Search for nearest obstacle in front (with some angle tolerance)
        angle_range = num_ranges // 8  # ±22.5 degrees
        start_idx = max(0, front_idx - angle_range)
        end_idx = min(num_ranges, front_idx + angle_range)
        
        for i in range(start_idx, end_idx):
            dist = msg.ranges[i]
            if not math.isinf(dist) and not math.isnan(dist) and dist > 0:
                front_distance = min(front_distance, dist)
        
        # Decision logic
        twist = Twist()
        
        if front_distance < self.min_distance:
            # Obstacle too close: rotate in place
            twist.linear.x = 0.0
            twist.angular.z = self.rotate_speed
            self.get_logger().debug(f"Obstacle at {front_distance:.2f}m - rotating")
        else:
            # Safe to move forward
            twist.linear.x = self.forward_speed
            twist.angular.z = 0.0
            self.get_logger().debug(f"Clear path (distance: {front_distance:.2f}m) - moving forward")
        
        self.cmd_vel_publisher.publish(twist)


def main(args=None):
    rclpy.init(args=args)
    node = ReactiveAvoidanceNode()
    
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()


if __name__ == '__main__':
    main()
