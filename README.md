# EasyPaginator
Un mecanismo simple para paginado en UITableView



# Modo de uso

//Declarar el paginable
struct PaginableUser : PaginableObject {
    typealias type = User
    
    static func == (lhs: PaginableUser, rhs: PaginableUser) -> Bool {
        return lhs.data.id == rhs.data.id
    }
    
    var data: User
    var page: Int
}


//crear el paginador
  let paginator = PaginableArray<PaginableUser>()

//En contexto dentro de la clase
    func nextUserPage() {
        let page = self.paginator.lastPageAdded + 1
        self.requestUser(keywords: self.text, page: page)
    }
    
    func requestUser(keywords:String?, page:Int) {
        
        GetUsersRequest(
            keyword: keywords,
            contactsOnly: false,
            page: page
        ).rx_execute()
            .subscribe(
                onNext: { [weak self] (users) in
                    
                    self?.placeholder?
                        .configure(
                            title: "Users",
                            subtitle: "No users to show"
                    )
                    
                    if page == 1 {
                        self?.paginator.clear()
                    }
                    
                    self?.refreshControl.endRefreshing()
                    self?.paginator.add(users.map{PaginableUser($0, page: page)})
                    
                    self?.isLoading.accept(false)
                    self?.tableview.reloadData()
                },
                onError: { [weak self](error) in
                    self?.refreshControl.endRefreshing()
            }).disposed(by: self.disposeBag)
        
    }




extension AddFriendsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.placeholder?.animatePlaceholderView(showPlaceholder: self.paginator.elements.isEmpty, animated: true)
        return self.paginator.elements.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (self.paginator.elements.count-1) == indexPath.row && !self.paginator.isLast {
            self.nextUserPage()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ....
    }

}



