from lucas_kanade_additive import lucas_kanade_additive
from lucas_kanade_compositional import lucas_kanade_compositional
from lucas_kanade_inverse_compositional import lucas_kanade_inverse_compositional
from utils import *

def main():
    imgT_path = 'data/cv-lab/1.JPG'
    imgI_path = None #'/media/admin/data/github/codesmart/computer_vision/lucas-kanade/data/cv-lab/2.JPG'
    num_max_layers = 4
    lk_algorithm = lucas_kanade_inverse_compositional

    # read template and instance images
    imgT, imgI, transformer = read_images(imgT_path, imgI_path)

    imgT_octaves = list(transform.pyramid_gaussian(imgT, max_layer=num_max_layers))[::-1] # [::-1] is to reverse the octaves from small image to big image
    imgI_octaves = list(transform.pyramid_gaussian(imgI, max_layer=num_max_layers))[::-1]

    p = None
    for imgInow, imgTnow in zip(imgI_octaves, imgT_octaves):
        p, imgI_warped = lk_algorithm(imgTnow, imgInow, p=p)

        # double the translation components for next scale
        # if lk_algorithm == lucas_kanade_additive:
        p[0,2] = 2*p[0,2]
        p[1,2] = 2*p[1,2]

        show_images(imgTnow, imgI_warped)

if __name__ == '__main__':
    main()
