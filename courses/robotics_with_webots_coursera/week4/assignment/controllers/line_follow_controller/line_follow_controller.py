"""line_follow_controller controller."""

# You may need to import some classes of the controller module. Ex:
#  from controller import Robot, Motor, DistanceSensor
from controller import Robot
import numpy as np

# create the Robot instance.
robot = Robot()

# get the time step of the current world.
timestep = int(robot.getBasicTimeStep())

# get references to motors
left_motor = robot.getDevice("left wheel motor")
right_motor = robot.getDevice("right wheel motor")

# set motors to velocity control
left_motor.setPosition(float("inf"))
right_motor.setPosition(float("inf"))


# enable ground sensors
def enable_sensors(sensor_prefix, num_sensors):
    """
    Enable the sensors with given prefix and return the handles.
    """
    sensor_handles = []

    for i in range(num_sensors):
        sensor = robot.getDevice(f"{sensor_prefix}{i}")
        sensor.enable(timestep)
        sensor_handles.append(sensor)

    return sensor_handles


ground_sensors = enable_sensors("gs", 3)


def get_sensor_values(sensor_handles):
    """
    Returns the sensor values.
    """
    vals = []
    for sensor in sensor_handles:
        vals.append(sensor.getValue())

    return np.array(vals)

# constants
MAX_SPEED = 6.28
r = 0.0201
d = 0.052
delta_t = timestep / 1000
START_POINT_COUNT = 4

# buffer to note down corner counts
all_dark = False
all_dark_count = 0

xytheta = np.array([0, 0.0, np.pi / 2.0, 1]).reshape(4, 1)

phildot, phirdot = 0, 0
# Main loop:
# - perform simulation steps until Webots is stopping the controller
while robot.step(timestep) != -1:
    # Read the sensors:
    g = get_sensor_values(ground_sensors)
    print(g)

    # if only center ground sensor sees dark sport, move forward
    if g[0] > 500 and g[1] < 350 and g[2] > 500:  
        # drive straight
        all_dark = False
        if all_dark_count < 4:
            phildot, phirdot = 0.8 * MAX_SPEED, 0.8* MAX_SPEED

    # if all center ground sensor see dark sport, decide between corner and starting point
    elif g[0] < 350 and g[1] < 350 and g[2] < 350:
        # if all the ground sensors sense values < 300, then either its a corner or starting point
        if not all_dark:
            # there are 3 corners, count the corner until stop
            all_dark = True
            all_dark_count += 1

        # check if robot reached start point
        if all_dark and all_dark_count >= START_POINT_COUNT:
            phildot, phirdot = 0.4 * MAX_SPEED, 0.4 * MAX_SPEED

    elif g[2] < 550:  
        # if right sensor sees dark sport, turn right
        all_dark = False
        if all_dark_count < 4:
            phildot, phirdot = 0.4 * MAX_SPEED, 0.005 * MAX_SPEED

    elif g[0] < 550:  
        # turn left if left sensor sees dark spot
        all_dark = False
        if all_dark_count < 4:
            phildot, phirdot = 0.005 * MAX_SPEED, 0.4 * MAX_SPEED

    # stop when the robot is at starting point
    if not all_dark and all_dark_count >= START_POINT_COUNT:
        phildot, phirdot = 0, 0

    left_motor.setVelocity(phildot)
    right_motor.setVelocity(phirdot)

    # calculate left wheel, right wheel distances travelled
    d_r = r * phirdot * delta_t
    d_l = r * phildot * delta_t
    distance_travelled = (d_l + d_r) / 2.0
    deltheta = (d_r - d_l) / d

    # transform matrix
    transform = np.eye(4)
    transform[0, 3] = distance_travelled * np.cos(xytheta[2, 0] + deltheta / 2.0)
    transform[1, 3] = distance_travelled * np.sin(xytheta[2, 0] + deltheta / 2.0)
    transform[2, 3] = deltheta

    xytheta = transform @ xytheta

    print(
        f"x: {xytheta[0,0]:.03f}, y: {xytheta[1,0]:.03f}, theta: {xytheta[2,0]:.03f}, "
        f"delta from origin {np.linalg.norm(xytheta[:2]) * 100:.03f} cm"
    )
