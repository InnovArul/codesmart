import math, pygame


class BuildEnvironment:
    def __init__(self, map_dims) -> None:
        pygame.init()
        self.pointclouds = []

        # load the image
        self.externalmap = pygame.image.load("pics/floorplan.png")

        # map particulars
        self.mapH, self.mapW = map_dims
        self.map_name = "floor plan"

        # set the caption and paste the floor plan
        pygame.display.set_caption(self.map_name)
        self.map = pygame.display.set_mode((self.mapW, self.mapH))
        self.map.blit(self.externalmap, (0, 0))

        # colors
        self.black = (0, 0, 0)
        self.white = (255, 255, 255)
        self.red = (255, 0, 0)
        self.green = (0, 255, 0)
        self.blue = (0, 0, 255)
        self.gray = (70, 70, 70)

    def angle_distance_to_pos(self, distance, angle, curr_pos):
        x = distance * math.cos(angle) + curr_pos[0]
        y = distance * math.sin(angle) + curr_pos[1]
        return (int(x), int(y))
    
    
    def store_data(self, data):
        for element in data:
            point = self.angle_distance_to_pos(element[0], element[1], element[2])
            if point not in self.pointclouds:
                self.pointclouds.append(point)
                
    def show_sensor_data(self):
        self.infomap = self.map.copy()
        for point in self.pointclouds:
            self.infomap.set_at((point[0], point[1]), self.red)
                