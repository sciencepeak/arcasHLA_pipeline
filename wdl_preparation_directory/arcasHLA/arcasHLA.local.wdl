version 1.0

# This workflow is to run arcasHLA from https://github.com/RabadanLab/arcasHLA

workflow MyBestWorkflow {
    input {
        # the sample_id in an entity table, if any, stores some raw information of the samples
        # The base_file_name is the actual, concise, and actual sample_name throughout the code.
        String base_file_name

        # input bam file.
        File input_bam_file

        Int allocated_thread_number
    }

    call RunarcasHLA {
        input:
            sample_name = base_file_name,
            bam_file_name = input_bam_file,
            thread_number = allocated_thread_number
    }

    # Output files of the workflows.
    output {
        File final_output_genes_json_file = RunarcasHLA.output_genes_json_file
        File final_output_genotype_json_file = RunarcasHLA.output_genotype_json_file
    }
}

task RunarcasHLA {

    input {
        String sample_name
        File bam_file_name
        Int thread_number
    }

    command {
        # Rename the bam files
        cp ${bam_file_name} ${sample_name}.bam

        arcasHLA extract -t ${thread_number} ${sample_name}.bam
        arcasHLA genotype -t ${thread_number} ${sample_name}.extracted.1.fq.gz ${sample_name}.extracted.2.fq.gz
    }

    output {
        File output_genes_json_file = "${sample_name}.genes.json"
        File output_genotype_json_file = "${sample_name}.genotype.json"
    }

    runtime {
        memory: "32G"
        cpu: thread_number
        disks: "local-disk 375 SSD"
        docker: "wallen/arcashla:0.2.5"
    }

}
