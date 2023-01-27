version 1.0

task assembly_report_ {
	input {
		File json
	}

	command <<<
		python /home/report_to_html.py ~{json} 
	>>>

	output {
		File html = "assembly_report.html"
	}

	runtime {
		docker: "developmentontheedge/report_html:0.2"
	}
}

workflow assembly_report {
	input {
		File json
	}

	call assembly_report_ {
		input:
		json = json
	}

	output {
		File html = assembly_report_.html
	}
}
