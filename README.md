# 修正箇所

## 問題1.新規作成を再度行ったとき、既存データが上書きされる

### 原因

新規作成画面(ViewController)の作り方に問題があります。
53行目の「`Memo` オブジェクトがなければ作成」ですが、これが2度目以降の新規作成の際、作り直しがされていません。
62行目の `memo = Memo(context: context)` のところにブレイクポイントを設定してデバッグ実行すると、何度新規作成を行っても一度しか呼ばれていないことがわかると思います。

こうなってしまう原因は `viewDidLoad()` 内で `Memo` オブジェクトを生成していることにあります。
こちらもブレイクポイントを設定すればわかると思いますが、タブの切替を行っても一度しか呼び出されません。
従って、何度新規作成を行っても、最初に作られた1つの `Memo` オブジェクトを変更し、保存しているだけになっているのです。

### 対処方法

`Memo`オブジェクトは、「一時保存」ボタンがタップされたとき、必要に応じて作るようにしましょう。
(「問題1の修正箇所」と書かれているコードを参照してください)

```
// 編集の場合は詳細画面から渡されたself.memoを変更、
// 新規の場合は新しいMemoオブジェクトを作る
let memo: Memo = {
    if let memo = self.memo {
        return memo
    } else {
        let memo = Memo(context: self.context)
        return memo
    }
}()
memo.title = self.titleField.text
memo.company = self.companyField.text
...
```

`Memo`オブジェクトを作るタイミングを遅らせたことで、「一時保存」せずホームタブに戻ったとき、空っぽのメモが作られてしまう問題も解消されます。

### 根本的な問題解決のために

上記の方法で解決はしたものの、実はあまり良い方法ではありません。
現在の画面構成自体が、問題を起こしやすい構造になっていると思います。
それは、「新規作成画面がタブの1つになっている」という点です。
タブではなく、いまある詳細画面や編集画面のようにモーダル型で作ることで、 `ViewController` はその都度インスタンス化され、 `viewDidLoad()` もその都度呼び出され、 `Memo` オブジェクトも使い回されることはありません。
保存が成功したら `dismiss()` でモーダル表示した画面を閉じてしまえば、 `clearData()` する必要もありませんね。

例えば、新規作成画面はタブの1つとして作る代わりに、ホームタブの右上に「新規作成」ボタンを置き、これがタップされたらモーダル表示するような構成にすれば良いのではないかと思います。

## 問題2. 選択していない方が編集対象となることがある

この問題については再現ができなかったため、不具合を引き起こす可能性のある箇所について対処を行いました。

### 考えられる原因と対策

ホーム画面(MemoTableViewController)から対象のメモを選択したとき、`prepare(for:sender:)`で詳細画面に渡すメモをフェッチしなおしている処理があります。
(「問題2の修正箇所」と書かれているコードを参照してください)

```
let fetchRequest: NSFetchRequest<Memo> = Memo.fetchRequest()
fetchRequest.predicate = NSPredicate(format: "title = %@ and company = %@ and memoText = %@ and memoNum = %@ and memoDate = %@", editedTitle!, editedCompany!, editedMemoText!, editedMemoNum!, editedMemoData!)
// そのfetchRequestを満たすデータをfetchしてtask(配列だが要素を1種類しか持たないはず）に代入し、それを渡す
```

「取得できる要素が1つのはず」とありますが、複数の可能性も考えられます。
`NSPredicate`で条件を指定していますが、この条件すべてが同じデータが複数登録されていたら、その数だけ返ってきます。
また、このコードではソートの指定を行っていない(SQLでいう、ORDER BY)ため、返却順は順不同となります。つまり0番目の要素は、必ずしも先に登録したものとは限りません。

ここについては、既にフェッチしたものを`memoData`に持っているので、選択された位置に対応する`Memo`オブジェクトを
渡してあげれば良いのではないかと思います。

```
vc.detailData = self.memoData[indexPath!.row]
```

詳細画面(DetailViewController)から編集画面に遷移する場合も同様のことが言えます。
こちらは`detailData`が`Memo`オブジェクトなので、

```
vc.memo = self.detailData
```

としてあげれば良いのではないでしょうか？

### その他の考えられる原因と対策

ホーム画面で全ての`Memo`オブジェクトをフェッチする際も、並び順の指定がされていないため、順不同となります。
Core Dataは、エンティティの追加や削除、変更などが行われるとこの順序が変わる可能性があるため、あたかも選択したものと異なるメモが編集されたかのように見えている可能性があります。


対策としては、`Memo`オブジェクトのフェッチ時に並び順を指定することになります。
しかし今の`Memo`オブジェクトのモデルには、決まった並び順にするためのキーが存在しません。
そこで、`createdAt`というDate型のキーを追加し、以下のコード変更を行いました。

(「問題2の修正箇所(2)」と書かれているコードを参照してください)

* 「一時保存」のとき、現在の日時を `createdAt` に設定する
* ホーム画面でフェッチするとき、 `createdAt` で昇順ソートする

```
fetchRequest.sortDescriptors = [
    NSSortDescriptor(key: "createdAt", ascending: true)
]
```

> この修正前に作られたデータには日時が入っていないため、正しくソートされない可能性があります。
> 一度アプリを削除し、データを削除してください。

これで、追加・削除などの変更が行われても、作成した順が維持されるはずです。

## 余談・Core Dataとその他のデータ保存方法について

Core Dataはその仕組みや性質をしっかり理解して利用することができれば、強力な永続化ストレージとして機能します。
一方で初心者だけでなく、十分理解しきれていない中・上級者であっても問題に陥りやすいと良く言われています。

この難しいフレームワークにチャレンジされたのは大変すばらしい👍と思いますが、多分相当ご苦労されたのではないかと...
今回の課題(アプリ)のように、各データが独立し依存関係のないものであれば、JSONやXMLファイルとして保存・読み込む方式でも実現できたのではないかと思いました。もしこの辺りに興味があるのであれば、以下あたりを調べてみるとよいと思います。

* FileManagerとDocumentディレクトリへのアクセス
* CodableプロトコルとJSONDecoder/JSONEncoder
