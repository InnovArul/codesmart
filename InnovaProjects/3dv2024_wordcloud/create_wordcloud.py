import numpy as np
import imageio
from wordcloud import WordCloud, STOPWORDS, ImageColorGenerator
import matplotlib.pyplot as plt

def read_text_file(filepath):
    with open(filepath, "r") as f:
        contents = f.readlines()

    contents = [line.strip() for line in contents]
    return contents

if __name__ == '__main__':
    papers_file = "3dv_papers.txt"
    contents = read_text_file(papers_file)

    text = " ".join(contents)

    wordcloud = WordCloud(width=2000, height=1200, stopwords=STOPWORDS, max_words=100,
                          background_color='white').generate(text)
    wordcloud.to_file("wordcloud_direct.png")
    # figure = plt.figure(figsize=(8,6))
    # plt.imshow(wordcloud, interpolation='bilinear')
    # plt.axis("off")
    # # plt.show(block=True)

    # figure.set_size_inches(8, 6)
    # plt.savefig("wordcloud.png", dpi=600, bbox_inches='tight')
