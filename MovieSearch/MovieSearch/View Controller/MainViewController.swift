//
//  ViewController.swift
//  MovieSearch
//
//  Created by chiam shwuyeh on 2025-03-05.
//

import UIKit
import Combine
import IQKeyboardManagerSwift

fileprivate enum Section {
    case main
}

class MainViewController: UIViewController {
   
    /* =================================================================
     *                   MARK: - Local Initialization
     * ================================================================= */
    fileprivate var apiKey = "8d6aa4ca"
    fileprivate var cancellables = Set<AnyCancellable>()
    fileprivate var movieList = MovieDO()
    fileprivate var searchText = "movie"
    fileprivate var dataSource: UICollectionViewDiffableDataSource<Section, MovieList>?
   
    /* =================================================================
     *                   MARK: - Outlet Initialization
     * ================================================================= */
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    /* =================================================================
     *                   MARK: - Class Function
     * ================================================================= */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
        self.getMovieList(searchText: self.searchText)
        self.collectionView.delegate = self
    }
    
    fileprivate func getMovieList(searchText: String) {
        self.showLoadingScreen()
        API.initiateGETSingleObjectWithoutWrapper(module: .getMovie(searchText, self.apiKey), typeOf: MovieDO())
            .sink { response in
                self.hideLoadingScreen()
                switch response {
                case .finished: break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { list in
                print("success")
                self.movieList = list
                self.applySnapshot()
            }
            .store(in: &cancellables)
    }
    
    fileprivate func registerAllNecessaryCells() {
        self.collectionView.register(UINib(nibName: "MovieListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MovieListCollectionViewCell.reuseIdentifier)
    }
    
    fileprivate func processViewDetails(movie: MovieList) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "detailsViewController") as? DetailsViewController {
            viewController.passedMovieList = movie
            self.present(viewController, animated: true)
        }
    }
}

/* =================================================================
 *            MARK: - UICollectionView Delegate
 * ================================================================= */
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let visibleRect = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let indexPath = self.collectionView.indexPathForItem(at: visiblePoint) {
            if let image = self.movieList.search[indexPath.row].poster {
                AppHelper.setImage(fromURL: image, toImageView: self.backgroundImageView)
            }
        }
    }
}

/* =================================================================
 *            MARK: - UICollectionView Compositional Layout
 * ================================================================= */
extension MainViewController {
    fileprivate func setupCollectionView() {
        self.registerAllNecessaryCells()
        self.collectionView.collectionViewLayout = self.createLayout()
        self.createDataSource()
    }
    
    fileprivate func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            return self.createComponentSection()
        }
        return layout
    }

    fileprivate func createComponentSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        return section
    }
    
    fileprivate func createDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<Section, MovieList>(collectionView: self.collectionView) {
            collectionView, indexPath, list in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.reuseIdentifier, for: indexPath) as? MovieListCollectionViewCell else {
                fatalError("Couldn't dequeue collection view cell")
            }
            cell.configure(movie: list)
            cell.onViewActionHandler = self.processViewDetails
            
            return cell
        }
    }
    
    fileprivate func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieList>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.movieList.search)
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

/* =================================================================
 *                   MARK: - UISearchBar Delegate
 * ================================================================= */
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            self.getMovieList(searchText: text)
            IQKeyboardManager.shared.resignFirstResponder()
        }
    }
}

