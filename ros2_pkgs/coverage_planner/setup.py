from setuptools import find_packages, setup

package_name = 'coverage_planner'

setup(
    name=package_name,
    version='0.0.1',
    packages=find_packages(exclude=['test']),
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
        ('share/' + package_name + '/launch', ['launch/coverage.launch.py']),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='Yannis',
    maintainer_email='yannis@example.com',
    description='Coverage planning for vacuum cleaner robot',
    license='Apache-2.0',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            'coverage_planner_node = coverage_planner.coverage_planner_node:main',
        ],
    },
)
