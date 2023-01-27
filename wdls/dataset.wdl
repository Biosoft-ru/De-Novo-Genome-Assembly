version 1.0

task dataset_ {
	input {
		Array[File] reads
	}

	command <<<
		dataset create --type ConsensusReadSet crs.xml \
		~{sep=" " reads}

		for file in ~{sep=" " reads}; do
			fileabs=$(basename $file)
			sed -i "s/ResourceId=[\"].*${fileabs}/ResourceId=\"${fileabs}/g" crs.xml
		done
	>>>

	output {
		File xml = "crs.xml"
	}

	runtime {
		docker: "developmentontheedge/smrtlink:0.2"
	}
}

workflow dataset {
	input {
		Array[File] reads 
	}

	call dataset_ {
		input:
		reads = reads,
	}

	output {
		File xml = dataset_.xml
	}
}
