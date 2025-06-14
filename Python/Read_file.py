#This opens file.txt in read mode ("r") and reads its entire content into the content variable.
with open("file.txt", "r") as f:
    content = f.read()
print(content)
