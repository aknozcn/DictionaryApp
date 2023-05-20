//
//  DetailViewController.swift
//  DictionaryApp
//
//  Created by akin on 18.05.2023.
//

import UIKit
import AVFoundation
import Lottie

class DetailViewController: UIViewController, Storyboardable {

    // MARK: - IBOutlets
    @IBOutlet weak var wordDetailTableView: UITableView!
    @IBOutlet weak var voiceContainerView: UIView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var phoneticLabel: UILabel!
    @IBOutlet weak var filterMeaningCollectionView: UICollectionView!
    @IBOutlet weak var synonymsCollectionView: UICollectionView!
    @IBOutlet weak var cancelFilterButtonView: UIView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var synonymTitleLabel: UILabel!
    
    // MARK: - Variables
    private let viewModel = DetailViewModel(apiManager: APIManager())
    private var player: AVPlayer?
    private lazy var animationView: LottieAnimationView = {
        let animation = LottieAnimation.named("no-data")
        let view = LottieAnimationView(animation: animation)
        view.loopMode = .loop
        return view
    }()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupNavigationController()
        setupViewModel()
        setupTableView()
        setupFilterCollectionView()
        setupSynonymsCollectionView()
        fetchWords()
    }

    // MARK: - Actions
    @IBAction func voiceButtonClicked(_ sender: UIButton) {
        let mp3 = viewModel.firstWord?.phonetics.filter { !$0.audio.isEmpty }.first
        playWordSound(url: mp3?.audio ?? "")
    }

    @IBAction func cancelFilterButtonClicked(_ sender: UIButton) {
        viewModel.filterState = false
        cancelFilterButtonView.isHidden = true
        filterMeaningCollectionView.reloadData()
        wordDetailTableView.reloadData()
    }

    // MARK: - Public Methods
    func setSearchWord(word: String) {
        viewModel.setSearchWord(word: word)
    }
}

// MARK: - Private Methods
private extension DetailViewController {
    func setupViewModel() {
        viewModel.delegate = self
    }

    func setupViews() {
        cancelFilterButtonView.layer.cornerRadius = cancelFilterButtonView.frame.size.width / 2
        cancelFilterButtonView.layer.borderColor = Colors.filterSelectBorderColor.cgColor
        cancelFilterButtonView.layer.borderWidth = 1
        voiceContainerView.layer.cornerRadius = voiceContainerView.frame.size.width / 2
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }

    func setupTableView() {
        let nib = UINib(nibName: MeaningsCell.identifier, bundle: nil)
        wordDetailTableView.register(nib, forCellReuseIdentifier: MeaningsCell.identifier)
        wordDetailTableView.delegate = self
        wordDetailTableView.dataSource = self
    }

    func setupFilterCollectionView() {
        let nib = UINib(nibName: FilterMeaningCell.identifier, bundle: nil)
        filterMeaningCollectionView.register(nib, forCellWithReuseIdentifier: FilterMeaningCell.identifier)
        filterMeaningCollectionView.delegate = self
        filterMeaningCollectionView.dataSource = self
    }

    func setupSynonymsCollectionView() {
        let nib = UINib(nibName: SynonymsCell.identifier, bundle: nil)
        synonymsCollectionView.register(nib, forCellWithReuseIdentifier: SynonymsCell.identifier)
        synonymsCollectionView.delegate = self
        synonymsCollectionView.dataSource = self
    }

    func fetchWords() {
        Loading.shared.show()
        viewModel.fetchWordDetail()
        viewModel.fetchSynonymsWords()
    }

    func filterCellSelectState(collectionView: UICollectionView, indexPath: IndexPath, isSelected: Bool) {
        cancelFilterButtonView.isHidden = false
        let color = isSelected ? Colors.filterSelectBorderColor : Colors.filterDeSelectBorderColor
        if let cell = collectionView.cellForItem(at: indexPath) as? FilterMeaningCell {
            cell.layer.borderColor = color.cgColor
            cell.layer.borderWidth = 1
        }
    }
    
    func setViewsHiddenState(isHidden: Bool) {
        voiceContainerView.isHidden = isHidden
        synonymsCollectionView.isHidden = isHidden
        topContainerView.isHidden = isHidden
        synonymTitleLabel.isHidden = isHidden
        wordDetailTableView.isHidden = isHidden
    }

    func playWordSound(url: String) {
        guard let url = URL(string: url) else {
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = AVPlayer(url: url)
            guard let player = player
                else
            {
                return
            }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.meaningsCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getDefinitionCount(for: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = wordDetailTableView.dequeueReusableCell(withIdentifier: MeaningsCell.identifier, for: indexPath) as? MeaningsCell else {
            return UITableViewCell()
        }

        if let meaning = viewModel.getWordMeaning(for: indexPath) {
            cell.configure(meaning: meaning)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == filterMeaningCollectionView else {
            return
        }
        
        filterCellSelectState(collectionView: collectionView, indexPath: indexPath, isSelected: true)
        let partOfSpeech = viewModel.firstWord?.meanings[indexPath.row].partOfSpeech
        let filteredMeaning = viewModel.firstWord?.meanings.filter { $0.partOfSpeech == partOfSpeech }
        viewModel.setFilteredMeanings(meanings: filteredMeaning ?? [])
        viewModel.filterState = true
        wordDetailTableView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard collectionView == filterMeaningCollectionView else {
            return
        }
        
        filterCellSelectState(collectionView: collectionView, indexPath: indexPath, isSelected: false)
    }
}

// MARK: - UICollectionViewDataSource
extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let isFilterCollectionView = (collectionView == filterMeaningCollectionView) ? true : false
        let meaningCount = viewModel.firstWord?.meanings.count ?? 0
        let synonymsCount = viewModel.getHighScoreSynonyms.count
        return isFilterCollectionView ? meaningCount : synonymsCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case filterMeaningCollectionView:
            guard let cell = filterMeaningCollectionView.dequeueReusableCell(withReuseIdentifier: FilterMeaningCell.identifier, for: indexPath) as? FilterMeaningCell else {
                return UICollectionViewCell()
            }
            let partOfSpeech = viewModel.firstWord?.meanings[indexPath.row].partOfSpeech.capitalized ?? ""
            cell.configure(meaning: partOfSpeech)
            return cell
        case synonymsCollectionView:
            guard let cell = synonymsCollectionView.dequeueReusableCell(withReuseIdentifier: SynonymsCell.identifier, for: indexPath) as? SynonymsCell else {
                return UICollectionViewCell()
            }
            cell.configure(word: viewModel.getHighScoreSynonyms[indexPath.row].word)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let partOfSpeech = viewModel.firstWord?.meanings[indexPath.row].partOfSpeech ?? ""
        let synonyms = viewModel.synonyms?[indexPath.row].word ?? ""
        let item = (collectionView == filterMeaningCollectionView) ? partOfSpeech : synonyms

        guard let font = UIFont(name: Fonts.robotoRegular, size: 11) else {
            return CGSize(width: 0, height: 33)
        }

        let textWidth = item.size(withAttributes: [.font: font]).width
        let cellWidth = textWidth + 30
        let cellHeight: CGFloat = 33
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - DetailViewModelDelegate
extension DetailViewController: DetailViewModelDelegate {
    func wordFetched() {
        setViewsHiddenState(isHidden: false)
        wordLabel.text = viewModel.firstWord?.word.capitalized
        phoneticLabel.text = viewModel.firstWord?.phonetic
        wordDetailTableView.reloadData()
        filterMeaningCollectionView.reloadData()
        Loading.shared.hide()
    }
    func wordFetchFailed() {
        setViewsHiddenState(isHidden: true)
        view.addSubview(animationView)
        animationView.frame = view.bounds
        animationView.play()
    }
    
    func synonymsWordsFetched() {
        synonymsCollectionView.reloadData()
    }
}
