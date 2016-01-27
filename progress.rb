#!/usr/bin/env ruby
# Skrypt
require 'colorize'
require 'csv'    
require 'set'
require 'json'

config = JSON.parse(File.read('config.json'))

classifiersSet = config["classifiersSet"]
generatorsSet = config["generatorsSet"]
chunksSet = config["chunksSet"]
chunkSizeSet = config["chunkSizeSet"]
thresholdSet = config["thresholdSet"]
budgetSet = config["budgetSet"]
timeCut = config["timeCut"]

experimentsCount = generatorsSet.length * classifiersSet.length * chunksSet.length * chunkSizeSet.length * thresholdSet.length * budgetSet.length
experimentNumber = 0
progress = 0

for chunks in chunksSet
for chunkSize in chunkSizeSet
for threshold in thresholdSet
for classifier in classifiersSet
for generator in generatorsSet
for budget in budgetSet
	experimentNumber += 1

	classifierName = classifier.split('.').last.downcase
	generatorName = generator.split('.').last.downcase

	outputFilename = "results/#{classifierName}_#{generatorName}_i_#{chunks}_s_#{chunkSize}_t_#{threshold}_b_#{budget}.csv"

    if File.size?"#{outputFilename}"
        progress += 1
    end
end
end
end
end
end
end

puts "#{progress} / #{experimentsCount} = #{progress.to_f / experimentsCount}"
