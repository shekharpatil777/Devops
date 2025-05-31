# 11. Create a list
my_list = [1, 2, 3, 4, 5]
print(f"My list: {my_list}")

# 12. Access elements in a list
first_element = my_list[0]
print(f"First element: {first_element}")

# 13. Append to a list
my_list.append(6)
print(f"List after appending: {my_list}")

# 14. Insert into a list
my_list.insert(2, 10)
print(f"List after inserting: {my_list}")

# 15. Remove from a list
my_list.remove(3)
print(f"List after removing: {my_list}")

# 16. Create a tuple
my_tuple = (10, 20, 30)
print(f"My tuple: {my_tuple}")

# 17. Access elements in a tuple
first_tuple_element = my_tuple[0]
print(f"First tuple element: {first_tuple_element}")

# 18. Create a dictionary
my_dict = {"name": "Bob", "age": 25}
print(f"My dictionary: {my_dict}")

# 19. Access values in a dictionary
name_value = my_dict["name"]
print(f"Name: {name_value}")

# 20. Add a key-value pair to a dictionary
my_dict["city"] = "New York"
print(f"Dictionary after adding: {my_dict}")

# 21. Get keys and values from a dictionary
keys = my_dict.keys()
values = my_dict.values()
print(f"Keys: {keys}")
print(f"Values: {values}")

# 22. Create a set
my_set = {1, 2, 2, 3, 4, 4, 5}
print(f"My set: {my_set}") # Duplicate elements are automatically removed

# 23. Add to a set
my_set.add(6)
print(f"Set after adding: {my_set}")

# 24. Remove from a set
my_set.remove(3)
print(f"Set after removing: {my_set}")

# 25. Check if an element is in a list/tuple/set/dictionary (keys)
is_present_list = 3 in my_list
is_present_tuple = 20 in my_tuple
is_present_set = 5 in my_set
is_present_dict = "name" in my_dict
print(f"Is 3 in list? {is_present_list}")
print(f"Is 20 in tuple? {is_present_tuple}")
print(f"Is 5 in set? {is_present_set}")
print(f"Is 'name' a key in dict? {is_present_dict}")