#!/usr/bin/env ruby

classifiersSet = [ "moa.classifiers.functions.Perceptron" ]
generatorsSet = [ "generators.WaveformGeneratorDrift" ]
chunksSet = [ 1000 ]
chunkSizeSet = [ 1000 ]
thresholdSet = [ 0.5]
budgetSet = [0.1]

for chunks in chunksSet
for chunkSize in chunkSizeSet
for threshold in thresholdSet
for classifier in classifiersSet
for generator in generatorsSet
for budget in budgetSet
	classifierName = classifier.split('.').last.downcase
	generatorName = generator.split('.').last.downcase
	outputFilename = "#{classifierName}_#{generatorName}_i_#{chunks}_s_#{chunkSize}_t_#{threshold}_b_#{budget}.csv"
	command = "java -cp moa.jar -javaagent:sizeofag.jar moa.DoTask \"EvaluatePrequentialActive -l #{classifier} -s #{generator} -i #{chunks} -b #{budget} -r #{threshold} -c #{chunkSize}\" > results/#{outputFilename}"
	puts command
	system(command)
end
end
end
end
end
end

#java -cp moa.jar -javaagent:sizeofag.jar moa.DoTask "EvaluatePrequentialActive -l moa.classifiers.functions.Perceptron -s generators.WaveformGeneratorDrift -i 1000 -b 0.101 -r 0.751 -c 1000" > res.csv