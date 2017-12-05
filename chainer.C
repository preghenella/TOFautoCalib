chainer(const Char_t *filelist, const Char_t *name, const Char_t *output)
{

  ifstream filein(filelist);
  Int_t nfiles = 0, nlost = 0;
  Char_t filename[4096];
  TFile file(output, "RECREATE");
  TChain c(name);

  while(1) {
    filein.getline(filename, 4096);
    if (filein.eof()) break;
    printf("adding file: %s\n", filename);
    if (c.Add(filename)) {
      printf("file %s successfully added\n", filename);
      nfiles++;
    }
    else {
      printf("cannot add file %s\n", filename);
      nlost++;
    }
  }

  c.Write();
  file.Close();
  
  printf("%d files chained, %d files lost\n", nfiles, nlost);

}
