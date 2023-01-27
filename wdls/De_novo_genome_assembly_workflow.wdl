version 1.0

import "pbindex.wdl" as pbindex
import "dataset.wdl" as dataset
import "pb_assembly_hifi.wdl" as pb_assembly_hifi

workflow de_novo_assembly {
	input{
		Array[File] reads
	}

	Array[Int] indexes = range(length(reads))

	scatter (i in indexes) {
		call pbindex.pbindex as pbindex_ {
			input:
			bam = reads[i]
		}
	}

	Array[File] bams_pbi = pbindex_.bam_pbi

	call dataset.dataset as make_xml {
		input:
		reads = reads
	}

	File xml = make_xml.xml

	call pb_assembly_hifi.pb_assembly_hifi as assembly {
		input:
		xml = xml,
		reads = reads,
		reads_pbi = bams_pbi
	}

	output {
		File haplotigs_fasta = assembly.haplotigs_fasta
		File primary_fasta = assembly.primary_fasta
		File report_json = assembly.report_json
	}
}
