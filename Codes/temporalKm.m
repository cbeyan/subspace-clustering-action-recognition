% temporalKm - a temporal pruning strategy implemented and proposed in [1]
% This function selects and prunes temporal frames to reach min(timestamps of entire dataset),
% by using k-means clustering.
%
% --- INPUT ---
%  - data : d-by-1 cell-type array dataset; each cell entry is a sample of the given dataset, a 3-by-19-by-T
%           matrix representing the XYZ skeleton joints acquired in T timestamps.
% --- OUTPUT ---
%  - data : d-by-1 cell-type array dataset; each cell entry is a sample of the given dataset, a 3-by-19-by-T
%           matrix representing the XYZ skeleton joints acquired in T timestamps.
%           T is pruned according to the method developed in [1].
%
% Giancarlo Paoletti
% Copyright 2020 Giancarlo Paoletti (giancarlo.paoletti@iit.it)
% Please, email me if you have any question.
%
% Disclaimer:
% The software is provided "as is", without warranty of any kind, express or implied, 
% including but not limited to the warranties of merchantability, 
% fitness for a particular purpose and noninfringement. In no event shall the authors, 
% PAVIS or IIT be liable for any claim, damages or other liability, whether in an action of contract, 
% tort or otherwise, arising from, out of or in connection with the software 
% or the use or other dealings in the software.
% 
% LICENSE:
% This project is licensed under the terms of the MIT license.
% This project incorporates material from the projects listed below (collectively, "Third Party Code").
% This Third Party Code is licensed to you under their original license terms.
% We reserves all other rights not expressly granted, whether by implication, estoppel or otherwise.
%
% Copyright (c) 2020 Giancarlo Paoletti, Jacopo Cavazza, Cigdem Beyan and Alessio Del Bue
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
% documentation files (the "Software"), to deal in the Software without restriction, including without
% limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
% the Software, and to permit persons to whom the Software is furnished to do so, subject to the following
% conditions:
% The above copyright notice and this permission notice shall be included in all copies or substantial
% portions of the Software.
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
% LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
% IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
% WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
% SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% References
% [1] Giancarlo Paoletti, Jacopo Cavazza, Cigdem Beyan and Alessio Del Bue (2020).
%     Subspace Clustering for Action Recognition with Covariance Representations and Temporal Pruning.
%     International Conference on Pattern Recognition (ICPR).

function data = temporalKm(data)
    for i=1:size(data,1)
        n(i,:) = size(data{i,1},3);
    end
    n = min(n);
    dump = data;
    clear data
    for i=1:size(dump,1)
        % D x N matrix of i-th sample: D = timestamps, N = concatenated xyz features
        for j=1:size(dump{i,1},3)
            X(j,:) = reshape(dump{i,1}(:,:,j).',1,[]);
        end
        grps = kmeans(X,n);
        clear X
        % Pick cluster index values, slice data and mean
        for j=1:n
            data{i,1}(:,:,j) = mean(dump{i,1}(:,:,find(grps==j)),3);
        end
        clear grps
    end
    fprintf('temporalKm strategy done: all samples pruned to %d timestamps.\n', n)
end
