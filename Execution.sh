#Step 1: Inference of whole paranome
wgd dmd Acorus_americanus.fa
#Step 2: Construction of whole-paranome Ks distribution
wgd ksd -n 100 wgd_dmd/Acorus_americanus.fa.tsv Acorus_americanus.fa -o wgd_ksd
#Step 3: Inference of collinearity and anchor-pair Ks distribution
wgd syn -f mRNA -a Name wgd_dmd/Acorus_americanus.fa.tsv Acorus_americanus.gff3 -ks wgd_ksd/Acorus_americanus.fa.tsv.ks.tsv -o wgd_syn
#Step 4: Construction of mixed Ks distributions
wgd dmd --globalmrbh Acorus_americanus Acorus_tatarinowii Posidonia_oceanica Spirodela_intermedia Aquilegia_coerulea -o wgd_globalmrbh
wgd ksd -n 100 wgd_globalmrbh/global_MRBH.tsv Acorus_americanus Acorus_tatarinowii Posidonia_oceanica Spirodela_intermedia Aquilegia_coerulea -o wgd_globalmrbh_ks
wgd viz -d wgd_globalmrbh_ks/global_MRBH.tsv.ks.tsv -fa Acorus_americanus -epk wgd_ksd/Acorus_americanus.fa.tsv.ks.tsv -ap wgd_syn/iadhore-out/anchorpoints.txt -sp speciestree.nw -o wgd_viz_mixed_Ks --plotelmm --plotapgmm --reweight
#Step 5: Find anchor pairs within the 95% CI of WGD peak
wgd peak --heuristic wgd_ksd/Acorus_americanus.fa.tsv.ks.tsv -ap wgd_syn/iadhore-out/anchorpoints.txt -sm wgd_syn/iadhore-out/segments.txt -le wgd_syn/iadhore-out/list_elements.txt -mp wgd_syn/iadhore-out/multiplicon_pairs.txt -n 1 4 -o wgd_peak
#Step 6: Construction of anchor pair-guided orthogroups
wgd dmd -f Acorus_americanus -ap wgd_peak/AnchorKs_FindPeak/Acorus_americanus.fa.tsv.ks.tsv_95%CI_AP_for_dating_weighted_format.tsv -o wgd_dmd_ortho Papaver_setigerum Aquilegia_coerulea Aquilegia_oxysepala Nelumbo_nucifera Telopea_speciosissima Protea_cynaroides Tetracentron_sinense Trochodendron_aralioides Potamogeton_acutifolius Spirodela_intermedia Amorphophallus_konjac Acanthochlamys_bracteata Dioscorea_alata Dioscorea_rotundata Asparagus_setaceus Phalaenopsis_equestris Dendrobium_nobile Acorus_americanus -n 18
#Step 7: Molecular dating of WGD
wgd focus --protcocdating --aamodel lg wgd_dmd_ortho/merge_focus_ap.tsv -sp dating_tree.nw.addtime_19sp -o wgd_dating -d mcmctree -ds 'burnin = 2000' -ds 'sampfreq = 1000' -ds 'nsample = 20000' Papaver_setigerum Aquilegia_coerulea Aquilegia_oxysepala Nelumbo_nucifera Telopea_speciosissima Protea_cynaroides Tetracentron_sinense Trochodendron_aralioides Potamogeton_acutifolius Spirodela_intermedia Amorphophallus_konjac Acanthochlamys_bracteata Dioscorea_alata Dioscorea_rotundata Asparagus_setaceus Phalaenopsis_equestris Dendrobium_nobile Acorus_americanus
