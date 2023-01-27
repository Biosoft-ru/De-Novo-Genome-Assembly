version 1.0

task pbindex_ {
	input {
		File bam
	}

	command <<<
		pbindex ~{bam}
		mv ~{bam}.pbi .
	>>>

	String bam_base = basename("${bam}")

	output {
		File bam_pbi = "${bam_base}.pbi"
	}

	runtime {
		docker: "developmentontheedge/smrtlink:0.2"
	}
}

workflow pbindex {
	input {
		File bam
	}

	call pbindex_ {
		input:
		bam = bam,
	}

	output {
		File bam_pbi = pbindex_.bam_pbi
	}
}
