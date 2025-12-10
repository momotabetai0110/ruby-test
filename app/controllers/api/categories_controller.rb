class Api::CategoriesController < Api::HelperController
  before_action :set_category, only: [ :show, :update, :destroy ]

  # カテゴリーを全件取得する
  # カテゴリーが存在しない場合は未登録の旨をメッセージを返す
  # @return [Array<Categories>] カテゴリー一覧
  def index
    categories = Category.all
    if categories.empty?
     render json: { status: "OK", result: "カテゴリーが未登録です" }, status: :ok
     return
    end
    render json: { status: "OK", result: categories }, status: :ok
  end

  # IDを指定してカテゴリーを取得する
  # そのIDに対応するカテゴリーが存在しない場合は存在しない旨をメッセージを返す
  # @return [Category] カテゴリー情報
  def show
    render json: { status: "OK", result: @category }, status: :ok
  end

  # 受け取った値から新規カテゴリーを作成する
  # @param category_params [ActionController::Parameters] カテゴリー名、説明を含んだパラメータ
  # @return [Hash] 作成したカテゴリー情報
  # @return [Hash] バリデーションエラー:エラーメッセージ
  def create
    category = Category.create(category_param)
    if category.persisted?
      render json: { status: "OK", result: category }, status: :created
      return
    else
      error_handling(category.errors.full_messages, :unprocessable_entity)
    end
  end

  # IDで指定したカテゴリーの情報を更新する
  # そのIDに対応するカテゴリーが存在しない場合は存在しない旨をメッセージを返す
  # @param category_params [ActionController::Parameters] カテゴリー名、説明を含んだパラメータ
  # @return [Hash] 更新したカテゴリー情報
  # @return [Hash] バリデーションエラー:エラーメッセージ
  def update
    if @category.update(category_param)
      render json: { status: "OK", result: @category }, status: :ok
      return
    else
      error_handling(@category.errors.full_messages, :unprocessable_entity)
    end
  end

  # IDで指定したカテゴリーを削除する
  # そのIDに対応するカテゴリーが存在しない場合は存在しない旨をメッセージを返す
  # @return [Hash] 削除したカテゴリー情報 { status: "OK", result: category }
  def destroy
    category = @category.destroy
    if category.destroyed?
      render json: { status: "OK", result: category }, status: :ok
      return
    else
      error_handling(@category.errors.full_messages, :unprocessable_entity)
    end
  end

  private

  def category_param
    params.require(:category).permit(:name, :description)
  end

  def set_category
    @category = Category.find_by(id: params[:id])
    if @category.nil?
      render json: { status: "NG", errors: [ "[ID:#{params[:id]}]そのカテゴリーは見つかりません" ] }, status: :not_found
      return
    end
  end
end
