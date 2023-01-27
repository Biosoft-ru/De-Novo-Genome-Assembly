version 1.0

task pb_assembly_hifi_ {
	input {
		File xml
		Array[File] reads
		Array[File] reads_pbi
	}

	command <<<
		for file in ~{sep=" " reads} ~{sep=" " reads_pbi};
		do
			mv $file $(dirname ~{xml})
		done
		pbcromwell run pb_assembly_hifi \
		-e ~{xml}

		mv $(readlink "cromwell_out/outputs/final_purged_haplotigs.fasta") \
		final_purged_haplotigs.fasta
		mv $(readlink "cromwell_out/outputs/final_purged_primary.fasta") \
		final_purged_primary.fasta
		mv $(readlink "cromwell_out/outputs/polished_assembly.report.json") \
		polished_assembly.report.json
	>>>

	output {
		File haplotigs_fasta = "final_purged_haplotigs.fasta"
		File primary_fasta = "final_purged_primary.fasta"
		File report_json = "polished_assembly.report.json"
	}

	runtime {
		docker: "developmentontheedge/smrtlink:0.2"
	}
}

workflow pb_assembly_hifi {
	input {
		File xml
		Array[File] reads 
		Array[File] reads_pbi
	}

	call pb_assembly_hifi_ {
		input:
		xml = xml,
		reads = reads,
		reads_pbi = reads_pbi
	}

	output {
		File haplotigs_fasta = pb_assembly_hifi_.haplotigs_fasta
		File primary_fasta = pb_assembly_hifi_.primary_fasta
		File report_json = pb_assembly_hifi_.report_json
	}
}
