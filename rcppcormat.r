## *******************************
rcppcormat <- function(snpmat){
    ## require
    require(Rcpp)
    require(RcppEigen)
    require(inline)
    ## rcpp
    crossprodCpp <- '
    using Eigen::Map;
    using Eigen::MatrixXd;
    using Eigen::Lower;

    // set constants

    const Map<MatrixXd> A(as<Map<MatrixXd> >(AA));
    const int n(A.cols());

    // create n x n matrix

    MatrixXd AtA(MatrixXd(n, n)

    // zero out the matrix

    .setZero()

    // treat what follows as symmetric matrix, use lower

    .selfadjointView<Lower>()

    // sum of B + AA

    .rankUpdate(A.adjoint()));

    // return

    return wrap(AtA);
    '

    ## compile the cross product function
    cpcpp <- cxxfunction(signature(AA="matrix"), crossprodCpp,
    plugin="RcppEigen", verbose=FALSE)

    cormat <- cpcpp(snpmat)

    ## post work
    cormatdiag <- diag(cormat)
    cormat <- sweep(cormat, 1, cormatdiag, "/")
    cormat <- sweep(cormat, 2, cormatdiag, "/")
    return(cormat)

}
