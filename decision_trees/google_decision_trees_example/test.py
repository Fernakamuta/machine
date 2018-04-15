import setup
import decisions

training_data = decisions.training_data
my_tree = decisions.build_tree(training_data)
decisions.classify(training_data[1], my_tree)

decisions.print_tree(my_tree)

testing_data = [
    ['Green', 3],
    ['Yellow', 4],
    ['Red', 2],
    ['Red', 1],
    ['Yellow', 3],
]

for row in testing_data:
    print ("Actual: %s. Predicted: %s" %
           (row[-1], decisions.print_leaf(decisions.classify(row, my_tree))))
