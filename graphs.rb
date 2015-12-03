#!/usr/bin/env ruby
# Graphs
require 'colorize'
require 'csv'    
require 'set'
require 'json'
require 'matrix'

classifiersSet = [ "moa.classifiers.functions.Perceptron", "moa.classifiers.bayes.NaiveBayes", "moa.classifiers.lazy.kNN" ]
generatorsSet = [ "generators.WaveformGeneratorDrift", "generators.RandomTreeGenerator", "generators.LEDGeneratorDrift" ]
chunksSet = [ 100, 1000, 10000, 100000 ]
chunkSizeSet = [ 10, 100, 1000 ]
thresholdSet = [ 0.25, 0.5, 0.75 ]
budgetSet = [ 0.125, 0.25, 0.5, 0.75 ]

#results = CSV.read("results.csv")

file = File.read('results.json')
results = JSON.parse(file)


puts "#1 dla każdego klasyfikatora zależność od budżetu i thresholdu - może da się na jednym dla wszystkich baz [accuracy]".red
for classifier in classifiersSet
	data = Array.new(4){ Array.new(3) { |i| 0} }
	puts "\tclassifier #{classifier}".green
	results.each do |result|
		if result['classifier'] == classifier && result['chunks'] == 100000
			data[budgetSet.index(result['budget'])] [thresholdSet.index(result['threshold'])] += result['meanAccuracy'].to_f
		end
	end

	factor = (results.length-1) / ( 3 * 3 * 4 * 4 )

	data.map! { |row| row.map! { |v| v / factor} }
	#puts data

	CSV.open("#{classifier}_accuracy.csv", "w") do |csv|
		data.each do |row|
			csv << row
		end
	end
end

puts "#2 dla każdego klasyfikatora zależność od budżetu i thresholdu - może da się na jednym dla wszystkich baz [sd]".red
for classifier in classifiersSet
	data = Array.new(4){ Array.new(3) { |i| 0} }
	puts "\tclassifier #{classifier}".green
	results.each do |result|
		if result['classifier'] == classifier && result['chunks'] == 100000
			data[budgetSet.index(result['budget'])] [thresholdSet.index(result['threshold'])] += result['standardDeviation'].to_f
		end
	end

	factor = (results.length-1) / ( 3 * 3 * 4 * 4 )

	data.map! { |row| row.map! { |v| v / factor} }
	#puts data


	CSV.open("#{classifier}_standardDeviation.csv", "w") do |csv|
		data.each do |row|
			csv << row
		end
	end
end

puts "#3 dla każdego streamu różne klasyfikatory zależność jak wyżej [accuracy]".red

for generator in generatorsSet
	data = Array.new(4){ Array.new(3) { |i| 0} }
	puts "\tgenerator #{generator}".green
	results.each do |result|
		if result['generator'] == generator && result['chunks'] == 100000
			data[budgetSet.index(result['budget'])] [thresholdSet.index(result['threshold'])] += result['meanAccuracy'].to_f
		end
	end

	factor = (results.length-1) / ( 3 * 3 * 4 *4)

	data.map! { |row| row.map! { |v| v / factor} }
	#puts data


	CSV.open("#{generator}_accuracy.csv", "w") do |csv|
		data.each do |row|
			csv << row
		end
	end
end


puts "#3 dla każdego streamu różne klasyfikatory zależność jak wyżej [sd]".red

for generator in generatorsSet
	data = Array.new(4){ Array.new(3) { |i| 0} }
	puts "\tgenerator #{generator}".green
	results.each do |result|
		if result['generator'] == generator && result['chunks'] == 100000
			data[budgetSet.index(result['budget'])] [thresholdSet.index(result['threshold'])] += result['standardDeviation'].to_f
		end
	end

	factor = (results.length-1) / ( 3 * 3 * 4 * 4 )

	data.map! { |row| row.map! { |v| v / factor} }
	#puts data


	CSV.open("#{generator}_standardDeviation.csv", "w") do |csv|
		data.each do |row|
			csv << row
		end
	end
end