from env import BuildEnvironment
from sensors import LaserSensor
import sensors
import math, pygame
import numpy as np

if __name__ == "__main__":
    environment = BuildEnvironment((600, 1200))
    environment.original_map = environment.map.copy()
    laser = LaserSensor(200, environment.original_map, uncertainty=(0.5, 0.01))
    environment.map.fill((0, 0, 0))

    # pygame variable
    running = True

    while running:
        sensorON = False
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

            if pygame.mouse.get_focused():
                sensorON = True
            elif not pygame.mouse.get_focused():
                sensorON = False

        if sensorON:
            pos = pygame.mouse.get_pos()
            laser.position = pos # [400, 200]
            sensor_data = laser.sense_obstacles()
            environment.store_data(sensor_data)
            environment.show_sensor_data()

        if getattr(environment, "infomap", None) is not None:
            environment.map.blit(environment.infomap, (0, 0))

        # `pygame.display.update()` is a function in the Pygame library that updates the contents of
        # the entire display window. It is typically called after making changes to the display, such
        # as drawing shapes or images, to ensure that the changes are visible to the user.
        pygame.display.update()
