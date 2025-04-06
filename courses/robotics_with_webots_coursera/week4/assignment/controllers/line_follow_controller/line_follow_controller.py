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
left_motor = robot.getDevice('left wheel motor')
right_motor = robot.getDevice('right wheel motor')

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

MAX_SPEED = 3.14
# previous_time = timestep
r = 0.0201
d = 0.052
distances = 0
rotations = 0
delta_t = timestep / 1000

# Main loop:
# - perform simulation steps until Webots is stopping the controller
while robot.step(timestep) != -1:
    # Read the sensors:
    # Enter here functions to read sensor data, like:
    #  val = ds.getValue()
    g = get_sensor_values(ground_sensors)
    print(g)

    if (g[0] > 500 and g[1]<350 and g[2]>500): # drive straight
        phildot, phirdot = MAX_SPEED, MAX_SPEED
    # elif np.all(np.array(g) < 500):
        # phildot, phirdot = 0.0, 0.0
    elif(g[2]<550): # turn right
        phildot, phirdot = 0.3 * MAX_SPEED, 0.02*MAX_SPEED
    elif(g[0]<550): # turn right
        phildot, phirdot = 0.02 * MAX_SPEED, 0.3*MAX_SPEED

    
    left_motor.setVelocity(phildot)
    right_motor.setVelocity(phirdot)
    # print(previous_time, timestep, previous_time-timestep)

    distances += (r * delta_t * (phildot + phirdot) / 2.)
    rotations += (r * delta_t * (phirdot - phildot) / d)

    print(distances, rotations)
    # Process sensor data here.

    # Enter here functions to send actuator commands, like:
    #  motor.setPosition(10.0)
    pass

# Enter here exit cleanup code.
