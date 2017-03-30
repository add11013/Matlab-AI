function I = InfoCon(F1, F2)

% Influence Information Matrix - IIM

% H(X2)
X2.pd = fitdist(F2, 'normal');
X2.sample = linspace(X2.pd.mean - 5*X2.pd.std, X2.pd.mean + 5*X2.pd.std);
X2.pdf = pdf(X2.pd,X2.sample);

% X1 > 0
X1.pos_idx = find(F1>0);
X1.pos = F1(X1.pos_idx);
X1.pos_pd = fitdist(X1.pos,'normal');
X1.pos_sample = linspace(X1.pos_pd.mean - 5*X1.pos_pd.std, X1.pos_pd.mean + 5*X1.pos_pd.std);
X1.pos_pdf = pdf(X1.pos_pd, X1.pos_sample);

% X2|X1 > 0
X2.X1pos = F2(X1.pos_idx);
X2.X1pos_pd = fitdist(X2.X1pos,'normal');
X2.X1pos_sample = linspace(X2.X1pos_pd.mean - 5*X2.X1pos_pd.std, X2.X1pos_pd.mean + 5*X2.X1pos_pd.std);
X2.X1pos_pdf = pdf(X2.X1pos_pd, X2.X1pos_sample);

% pd(X2|X1pos_pdf) = pd(X2.X1pos_pdf) * pd(X1.pos_pdf)
X2.X1pos_together = X2.X1pos_pdf .* X1.pos_pdf;

% define beta1
beta1 = max(max(1,(max(X2.pdf,X2.X1pos_pdf) + 1e-10)));

% X1 < 0
X1.neg_idx = find(F1<0);
X1.neg = F1(X1.neg_idx);
X1.neg_pd = fitdist(X1.neg,'normal');
X1.neg_sample = linspace(X1.neg_pd.mean - 5*X1.neg_pd.std, X1.neg_pd.mean + 5*X1.neg_pd.std);
X1.neg_pdf = pdf(X1.neg_pd, X1.neg_sample);

% X2|X1 < 0
X2.X1neg = F2(X1.neg_idx);
X2.X1neg_pd = fitdist(X2.X1neg,'normal');
X2.X1neg_sample = linspace(X2.X1neg_pd.mean - 5*X2.X1neg_pd.std, X2.X1neg_pd.mean + 5*X2.X1neg_pd.std);
X2.X1neg_pdf = pdf(X2.X1neg_pd, X2.X1neg_sample);

% pd(X2|X1neg_pdf) = pd(X2.X1neg_pdf) * pd(X1.neg_pdf)
X2.X1neg_together = X2.X1neg_pdf .* X1.neg_pdf;

% define beta2
beta2 = max(max(1,(max(X2.pdf,X2.X1neg_pdf) + 1e-10)));

% sampling X1
X1.X1_pd = fitdist(F1, 'normal');
X1.sample = linspace(X1.X1_pd.mean - 5*X1.X1_pd.std, X1.X1_pd.mean + 5*X1.X1_pd.std);
X1.sample_pdf = pdf(X1.X1_pd, X1.sample);

X1.sample_pos_idx = find(X1.sample > 0);
X1.sample_neg_idx = find(X1.sample < 0);

X1.pos_pdf = X1.sample_pdf(X1.sample_pos_idx);
X1.neg_pdf = X1.sample_pdf(X1.sample_neg_idx);

X1.pos_sample = X1.sample(X1.sample_pos_idx);
X1.neg_sample = X1.sample(X1.sample_neg_idx);

X1.pos_sum_pdf = sum(X1.pos_pdf)*(X1.pos_sample(2)-X1.pos_sample(1));
X1.neg_sum_pdf = sum(X1.neg_pdf)*(X1.neg_sample(2)-X1.neg_sample(1));

% Infor contribution from POSITIVE X1 to X2
H.X2 = (X2.pdf*log(beta1./X2.pdf).')*(X2.sample(2) - X2.sample(1)); 
H.X2X1_pos = (X2.X1pos_together*log(beta1./X2.X1pos_pdf).')...
    *(X2.X1pos_sample(2)-X2.X1pos_sample(1))*(X1.pos_sample(2)-X1.pos_sample(1));
I.I1 = H.X2 - H.X2X1_pos;

% Infor contribution from NEGATIVE X1 to X2

H.X2X1_neg = (X2.X1neg_together*log(beta2./X2.X1neg_pdf).')...
    *(X2.X1neg_sample(2)-X2.X1neg_sample(1))*(X1.neg_sample(2)-X1.neg_sample(1));
I.I2 = H.X2 - H.X2X1_neg;

% Ic X1 to X2
I.I_X1X2 = (I.I1*X1.pos_sum_pdf + I.I2*X1.neg_sum_pdf)/2;
end
