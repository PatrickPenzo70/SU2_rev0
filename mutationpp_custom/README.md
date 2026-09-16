# Dati Mutation++ modificati

Il sottomodulo `subprojects/Mutationpp` punta al repository ufficiale di Mutation++,
dove non è possibile pushare. Questi due file vivono quindi qui:

- `data/mixtures/ArH2_87_13.xml` — miscela Ar/H2 87/13 (`GAS_MODEL= ArH2_87_13`), non presente upstream
- `data/transport/collisions.xml` — database degli integrali di collisione ridotto per questa miscela

Dopo un clone (e `git submodule update --init`), copiarli nel sottomodulo prima di compilare/lanciare:

    cp -r mutationpp_custom/data/* subprojects/Mutationpp/data/
