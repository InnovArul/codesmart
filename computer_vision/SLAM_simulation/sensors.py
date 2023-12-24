import math, pygame
import numpy as np


def add_uncertainty(distance, angle, sigma):
    """The function "add_uncertainty" adds uncertainty to the given distance and angle values by sampling
    from a multivariate normal distribution with the specified mean and covariance.

    Parameters
    ----------
    distance
        The distance is the measured distance from a point to another point.
    angle
        The angle parameter represents the angle of the object or point in a coordinate system. It is
    typically measured in radians or degrees.
    sigma
        The sigma parameter represents the standard deviation of the uncertainty in the distance and angle
    measurements. It is used to create a covariance matrix for the multivariate normal distribution from
    which the distance and angle values are sampled. A higher value of sigma indicates a higher level of
    uncertainty in the measurements.

    Returns
    -------
        the updated values of distance and angle after adding uncertainty.

    """
    mean = np.array([distance, angle])
    covariance = np.diag(sigma**2)
    distance, angle = np.random.multivariate_normal(mean=mean, cov=covariance)
    distance = max(distance, 0.0)
    angle = max(angle, 0.0)
    return [distance, angle]


class LaserSensor:
    def __init__(self, range, map, uncertainty) -> None:
        self.range = range
        self.map = map.copy()
        self.speed = 4  # rounds per second
        self.sigma = np.array(uncertainty)
        self.position = (0, 0)
        self.W, self.H = pygame.display.get_surface().get_size()

        self.sensed_obstacles = []

    def distance(self, obs_position):
        """The function calculates the Euclidean distance between the position of an object and the
        position of an obstacle.

        Parameters
        ----------
        obs_position
            The parameter `obs_position` represents the position of an obstacle.

        Returns
        -------
            the Euclidean distance between the self.position and obs_position.

        """
        return np.linalg.norm(np.array(self.position) - np.array(obs_position))

    def sense_obstacles(self):
        data = []
        x, y = self.position

        for angle in np.linspace(0, 2 * math.pi, 60, endpoint=False):
            new_x, new_y = (
                x + self.range * math.cos(angle),
                y + self.range * math.sin(angle),
            )

            for i in range(100):
                u = i / 100
                candidate_x = int(new_x * u + (1 - u) * x)
                candidate_y = int(new_y * u + (1 - u) * y)
                if 0 <= candidate_x < self.W and 0 <= candidate_y < self.H:
                    color = self.map.get_at((candidate_x, candidate_y))
                    # print(color)
                    if color[0] == 0 and color[1] == 0 and color[2] == 0:
                        distance = self.distance((candidate_x, candidate_y))
                        out = add_uncertainty(distance, angle=angle, sigma=self.sigma)
                        out.append(self.position)
                        data.append(out)
                        break

        return data
