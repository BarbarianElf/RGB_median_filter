import cv2
import numpy as np
from skimage.util import random_noise
from skimage import img_as_ubyte


filename = 'IMG.jpg'

image_in = cv2.imread(filename)
image_in = cv2.cvtColor(image_in, cv2.COLOR_BGR2RGB)
image_in_resized = cv2.resize(image_in, (256, 256))

image_snp = random_noise(image_in_resized, mode='s&p', seed=None, clip=True, amount=0.01)

image_out = img_as_ubyte(image_snp)
image_out = image_out.astype(np.uint8).tofile("IMG_SNP.raw")


# uncomment the commands below to see the results
# from matplotlib import pyplot as plt
# plt.figure(1), plt.imshow(I), plt.title('Origin')
# plt.figure(2), plt.imshow(sp), plt.title('Salt & Pepper')
# plt.show()
