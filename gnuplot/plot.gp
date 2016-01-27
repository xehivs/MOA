#!/usr/local/bin/gnuplot
set terminal png size 600,450 enhanced font 'Helvetica,11'
#set terminal png size 350,300 enhanced font 'Helvetica,7'

set datafile separator ','
set key top left

### ACCURACY

set ylabel 'Accuracy'
set format y "%.0f%%";
set yrange [0:100]

load 'config.cfg'

# LED Classificator to budget
set output 'led_class2bud.png'
set xrange [0:1]
set xlabel 'Budget'
set key title 'Classificator'
set title 'LED Generator'

plot 	'led_class2bud.csv' i 0 u 2:3 w l t 'NaiveBayes' ls 1, \
		'led_class2bud.csv' i 1 u 2:3 w l t 'Perceptron' ls 2, \
		'led_class2bud.csv' i 2 u 2:3 w l t 'kNN' ls 3, \
		'led_class2bud.csv' i 3 u 2:3 w l t 'RuleClassifier' ls 4

# Random Classificator to budget
set output 'random_class2bud.png'
set xrange [0:1]
set xlabel 'Budget'
set key title 'Classificator'
set title 'Random Tree Generator'

plot 	'random_class2bud.csv' i 0 u 2:3 w l t 'NaiveBayes' ls 1, \
		'random_class2bud.csv' i 1 u 2:3 w l t 'Perceptron' ls 2, \
		'random_class2bud.csv' i 2 u 2:3 w l t 'kNN' ls 3, \
		'random_class2bud.csv' i 3 u 2:3 w l t 'RuleClassifier' ls 4

# Wave Classificator to budget
set output 'wave_class2bud.png'
set xrange [0:1]
set xlabel 'Budget'
set key title 'Classificator'
set title 'Wave Generator'

plot 	'wave_class2bud.csv' i 0 u 2:3 w l t 'NaiveBayes' ls 1, \
		'wave_class2bud.csv' i 1 u 2:3 w l t 'Perceptron' ls 2, \
		'wave_class2bud.csv' i 2 u 2:3 w l t 'kNN' ls 3, \
		'wave_class2bud.csv' i 3 u 2:3 w l t 'RuleClassifier' ls 4


# LED Classificator to threshold
set output 'led_class2thre.png'
set xrange [0:1]
set xlabel 'Threshold'
set key title 'Classificator'
set title 'LED Generator'

plot 	'led_class2thre.csv' i 0 u 2:3 w l t 'NaiveBayes' ls 1, \
		'led_class2thre.csv' i 1 u 2:3 w l t 'Perceptron' ls 2, \
		'led_class2thre.csv' i 2 u 2:3 w l t 'kNN' ls 3, \
		'led_class2thre.csv' i 3 u 2:3 w l t 'RuleClassifier' ls 4

# Random Classificator to threshold
set output 'random_class2thre.png'
set xrange [0:1]
set xlabel 'Threshold'
set key title 'Classificator'
set title 'Random Tree Generator'

plot 	'random_class2thre.csv' i 0 u 2:3 w l t 'NaiveBayes' ls 1, \
		'random_class2thre.csv' i 1 u 2:3 w l t 'Perceptron' ls 2, \
		'random_class2thre.csv' i 2 u 2:3 w l t 'kNN' ls 3, \
		'random_class2thre.csv' i 3 u 2:3 w l t 'RuleClassifier' ls 4

# Wave Classificator to threshold
set output 'wave_class2thre.png'
set xrange [0:1]
set xlabel 'Threshold'
set key title 'Classificator'
set title 'Wave Generator'

plot 	'wave_class2thre.csv' i 0 u 2:3 w l t 'NaiveBayes' ls 1, \
		'wave_class2thre.csv' i 1 u 2:3 w l t 'Perceptron' ls 2, \
		'wave_class2thre.csv' i 2 u 2:3 w l t 'kNN' ls 3, \
		'wave_class2thre.csv' i 3 u 2:3 w l t 'RuleClassifier' ls 4

# Generators to budget
set output 'gen2bud.png'
set xrange [0:1]
set xlabel 'Budget'
set key title 'Generator'
set title ''

plot 	'gen2bud.csv' i 0 u 2:3 w l t 'LED' ls 1, \
		'gen2bud.csv' i 1 u 2:3 w l t 'RandomTree' ls 2, \
		'gen2bud.csv' i 2 u 2:3 w l t 'Waveform' ls 3

# Generators to threshold
set output 'gen2thre.png'
set xrange [0:1]
set xlabel 'Threshold'
set key title 'Generator'

plot 	'gen2thre.csv' i 0 u 2:3 w l t 'LED' ls 1, \
		'gen2thre.csv' i 1 u 2:3 w l t 'RandomTree' ls 2, \
		'gen2thre.csv' i 2 u 2:3 w l t 'Waveform' ls 3


# Budget to chunk size
set output 'bud2chunk.png'
set xrange [0:1]
set xlabel 'Budget'
set key noreverse title 'Chunk size'

plot 	'bud2chunk.csv' i 0 u 2:3 w l t '10' ls 1, \
		'bud2chunk.csv' i 1 u 2:3 w l t '100' ls 2, \
		'bud2chunk.csv' i 2 u 2:3 w l t '1000' ls 3, \
		'bud2chunk.csv' i 3 u 2:3 w l t '10000' ls 4

# Threshold to budget
set output 'thre2bud.png'
set xrange [0:1]
set xlabel 'Threshold'
set key title 'Budget'

plot 	'thre2bud.csv' i 0 u 2:3 w l t '0.2' ls 1, \
		'thre2bud.csv' i 1 u 2:3 w l t '0.4' ls 2, \
		'thre2bud.csv' i 2 u 2:3 w l t '0.6' ls 3, \
		'thre2bud.csv' i 3 u 2:3 w l t '0.8' ls 4, \
		'thre2bud.csv' i 4 u 2:3 w l t '1.0' ls 5

# Threshold to chunk size
set output 'thre2chunk.png'
set xrange [0:1]
set xlabel 'Threshold'
set key title 'Chunk size'

plot 	'thre2chunk.csv' i 0 u 2:3 w l t '10' ls 1, \
		'thre2chunk.csv' i 1 u 2:3 w l t '100' ls 2, \
		'thre2chunk.csv' i 2 u 2:3 w l t '1000' ls 3, \
		'thre2chunk.csv' i 3 u 2:3 w l t '10000' ls 4

###
###
###
###	STD
###
###
###

set ylabel 'Standard deviation'
set format y "%.1f";
set yrange [0:5]
set autoscale y


# LED Classificator to budget
set output 'led_class2bud_std.png'
set xrange [0:1]
set xlabel 'Budget'
set key title 'Classificator'
set title 'LED Generator'

plot 	'led_class2bud.csv' i 0 u 2:4 w l t 'NaiveBayes' ls 1, \
		'led_class2bud.csv' i 1 u 2:4 w l t 'Perceptron' ls 2, \
		'led_class2bud.csv' i 2 u 2:4 w l t 'kNN' ls 3, \
		'led_class2bud.csv' i 3 u 2:4 w l t 'RuleClassifier' ls 4

# Random Classificator to budget STD
set output 'random_class2bud_std.png'
set xrange [0:1]
set xlabel 'Budget'
set key title 'Classificator'
set title 'Random Tree Generator'

plot 	'random_class2bud.csv' i 0 u 2:4 w l t 'NaiveBayes' ls 1, \
		'random_class2bud.csv' i 1 u 2:4 w l t 'Perceptron' ls 2, \
		'random_class2bud.csv' i 2 u 2:4 w l t 'kNN' ls 3, \
		'random_class2bud.csv' i 3 u 2:4 w l t 'RuleClassifier' ls 4

# Wave Classificator to budget
set output 'wave_class2bud_std.png'
set xrange [0:1]
set xlabel 'Budget'
set key title 'Classificator'
set title 'Wave Generator'

plot 	'wave_class2bud.csv' i 0 u 2:4 w l t 'NaiveBayes' ls 1, \
		'wave_class2bud.csv' i 1 u 2:4 w l t 'Perceptron' ls 2, \
		'wave_class2bud.csv' i 2 u 2:4 w l t 'kNN' ls 3, \
		'wave_class2bud.csv' i 3 u 2:4 w l t 'RuleClassifier' ls 4


# LED Classificator to threshold
set output 'led_class2thre_std.png'
set xrange [0:1]
set xlabel 'Threshold'
set key title 'Classificator'
set title 'LED Generator'

plot 	'led_class2thre.csv' i 0 u 2:4 w l t 'NaiveBayes' ls 1, \
		'led_class2thre.csv' i 1 u 2:4 w l t 'Perceptron' ls 2, \
		'led_class2thre.csv' i 2 u 2:4 w l t 'kNN' ls 3, \
		'led_class2thre.csv' i 3 u 2:4 w l t 'RuleClassifier' ls 4

# Random Classificator to threshold
set output 'random_class2thre_std.png'
set xrange [0:1]
set xlabel 'Threshold'
set key title 'Classificator'
set title 'Random Tree Generator'

plot 	'random_class2thre.csv' i 0 u 2:4 w l t 'NaiveBayes' ls 1, \
		'random_class2thre.csv' i 1 u 2:4 w l t 'Perceptron' ls 2, \
		'random_class2thre.csv' i 2 u 2:4 w l t 'kNN' ls 3, \
		'random_class2thre.csv' i 3 u 2:4 w l t 'RuleClassifier' ls 4

# Wave Classificator to threshold
set output 'wave_class2thre_std.png'
set xrange [0:1]
set xlabel 'Threshold'
set key title 'Classificator'
set title 'Wave Generator'

plot 	'wave_class2thre.csv' i 0 u 2:4 w l t 'NaiveBayes' ls 1, \
		'wave_class2thre.csv' i 1 u 2:4 w l t 'Perceptron' ls 2, \
		'wave_class2thre.csv' i 2 u 2:4 w l t 'kNN' ls 3, \
		'wave_class2thre.csv' i 3 u 2:4 w l t 'RuleClassifier' ls 4

# Generators to budget
set output 'gen2bud_std.png'
set xrange [0:1]
set xlabel 'Budget'
set key title 'Generator'
set title ''

plot 	'gen2bud.csv' i 0 u 2:4 w l t 'LED' ls 1, \
		'gen2bud.csv' i 1 u 2:4 w l t 'RandomTree' ls 2, \
		'gen2bud.csv' i 2 u 2:4 w l t 'Waveform' ls 3

# Generators to threshold
set output 'gen2thre_std.png'
set xrange [0:1]
set xlabel 'Threshold'
set key title 'Generator'

plot 	'gen2thre.csv' i 0 u 2:4 w l t 'LED' ls 1, \
		'gen2thre.csv' i 1 u 2:4 w l t 'RandomTree' ls 2, \
		'gen2thre.csv' i 2 u 2:4 w l t 'Waveform' ls 3


# Budget to chunk size
set output 'bud2chunk_std.png'
set xrange [0:1]
set xlabel 'Budget'
set key noreverse title 'Chunk size'

plot 	'bud2chunk.csv' i 0 u 2:4 w l t '10' ls 1, \
		'bud2chunk.csv' i 1 u 2:4 w l t '100' ls 2, \
		'bud2chunk.csv' i 2 u 2:4 w l t '1000' ls 3, \
		'bud2chunk.csv' i 3 u 2:4 w l t '10000' ls 4

# Threshold to budget
set output 'thre2bud_std.png'
set xrange [0:1]
set xlabel 'Threshold'
set key title 'Budget'

plot 	'thre2bud.csv' i 0 u 2:4 w l t '0.2' ls 1, \
		'thre2bud.csv' i 1 u 2:4 w l t '0.4' ls 2, \
		'thre2bud.csv' i 2 u 2:4 w l t '0.6' ls 3, \
		'thre2bud.csv' i 3 u 2:4 w l t '0.8' ls 4, \
		'thre2bud.csv' i 4 u 2:4 w l t '1.0' ls 5

# Threshold to chunk size
set output 'thre2chunk_std.png'
set xrange [0:1]
set xlabel 'Threshold'
set key title 'Chunk size'

plot 	'thre2chunk.csv' i 0 u 2:4 w l t '10' ls 1, \
		'thre2chunk.csv' i 1 u 2:4 w l t '100' ls 2, \
		'thre2chunk.csv' i 2 u 2:4 w l t '1000' ls 3, \
		'thre2chunk.csv' i 3 u 2:4 w l t '10000' ls 4
