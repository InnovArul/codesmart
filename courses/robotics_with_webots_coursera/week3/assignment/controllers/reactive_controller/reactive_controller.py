"""reactive_controller controller."""

# You may need to import some classes of the controller module. Ex:
#  from controller import Robot, Motor, proximitySensor
from controller import Robot
import numpy as np

NUM_PROXIMITY_SENSORS = 8
NUM_LIGHT_SENSORS = 8

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

PROXIMITY_SENSOR_THRESHOLD = 77.6624000

# enable proximity sensors
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
    
def get_sensor_values(sensor_handles):
    """
    Returns the sensor values.
    """
    vals = []
    for sensor in sensor_handles:
        vals.append(sensor.getValue())

    return np.array(vals)

def get_front_proximity_sensor_vals(proximity_sensor_vals):
    # return left-front, right-front sensor vvalues
    return proximity_sensor_vals[[7, 0]]
    
def get_back_proximity_sensor_vals(proximity_sensor_vals):
    # return left-back, right-back sensor vvalues
    return (proximity_sensor_vals[[4,3]])
    
def get_left_proximity_sensor_vals(proximity_sensor_vals):
    # return left sensor values
    return (proximity_sensor_vals[[5]])

def is_obstacle_in_front(proximity_sensor_vals, threshold = 210):
    """
    Returns true if front sensor vals read greater than threshold
    """
    return np.any(get_front_proximity_sensor_vals(proximity_sensor_vals) >= threshold)
    
def is_obstacle_in_left(proximity_sensor_vals, threshold = 210):
    """
    Returns true if back sensor vals reads greater than threshold
    """
    return np.any(get_left_proximity_sensor_vals(proximity_sensor_vals) >= threshold)

def stop():
    left_motor.setVelocity(0)
    right_motor.setVelocity(0)

def move_forward():
    left_motor.setVelocity(np.pi)
    right_motor.setVelocity(np.pi)

def rotate_right():
    left_motor.setVelocity(np.pi)
    right_motor.setVelocity(-np.pi)


light_sensors = enable_sensors("ls", NUM_LIGHT_SENSORS)
proximity_sensors = enable_sensors("ps", NUM_PROXIMITY_SENSORS)

state = "MOVING_FORWARD"
move_forward()
rotation_count = 0

rotation_start_time = 0
total_rotation_time = 0

# Main loop:
while robot.step(timestep) != -1:
    # Read the sensors
    proximity_sensor_vals = get_sensor_values(proximity_sensors)
    # light_sensor_vals = get_sensor_values(light_sensors)
    # print(state)
    
    if state == "MOVING_FORWARD":
        if is_obstacle_in_front(proximity_sensor_vals, threshold=PROXIMITY_SENSOR_THRESHOLD):
            if rotation_count == 0:
                state = "ROTATE_180"
                print(f"transitioning to {state}")
                rotation_start_time = robot.getTime()
            else:
                state = "ROTATE_90_RIGHT"
                print(f"transitioning to {state}")
                rotation_start_time = robot.getTime()
        else:
            move_forward()

    elif state == "ROTATE_180":
        total_rotation_time = robot.getTime() - rotation_start_time
        if total_rotation_time <= 1.55:
            rotate_right()
        else:
            state = "MOVING_FORWARD"
            print(f"transitioning to {state}")
            rotation_count += 1

    elif state == "ROTATE_90_RIGHT":
        total_rotation_time = robot.getTime() - rotation_start_time
        if total_rotation_time <= 0.76:
            rotate_right()
        else:
            state = "MOVE_FORWARD_UNTIL_OBSTACLE_NOT_IN_LEFT"
            print(f"transitioning to {state}")
    
    elif state == "MOVE_FORWARD_UNTIL_OBSTACLE_NOT_IN_LEFT":
        if is_obstacle_in_left(proximity_sensor_vals, threshold=PROXIMITY_SENSOR_THRESHOLD):
            move_forward()
        else:
            state = "FINISH"
            print(f"transitioning to {state}")

    else:
        assert state == "FINISH"
        stop()


# Enter here exit cleanup code.
