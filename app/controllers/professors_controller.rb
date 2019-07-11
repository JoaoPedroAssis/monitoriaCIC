class ProfessorsController < ApplicationController

  # usando como pagina de selecao de professores (issue: select de professores)
  def index
    # conteudo do select de professores
    @professor = Professor.all
  end

  def new ; end

  def create
    @professor = Professor.create(professor_params)

    if !@professor.errors.any?
      flash[:notice] = "Registro realizado com sucesso!"
      log_in(@professor)
      redirect_to dashboard_path
    else
      flash[:danger] = @professor.errors.full_messages
      redirect_to new_professor_path
    end
  end
  # usando como pagina de confirmacao dos professores
  def identityconfirmation
    # procura o professor selecionado na lista
    @professor = Professor.where(:name => params[:professor][:name])[0]
    # faz o envio do e-mail de confirmação para o respectivo professor
    ProfessorMailer.with(professor: @professor).key_email.deliver_now
  end

  def update
    @professor = Professor.find_by_email(session[:user_id])
    @professor.update_attributes(professor_params)

    if !@professor.errors.any?
      flash[:notice] = "Cadastro atualizado com sucesso!"
    elsif
      flash[:danger] = @professor.errors.full_messages
    end

    redirect_to dashboard_path
  end

  protected

  def professor_params
    params.require(:professor).permit(:id, :name, :username, :email, :role, :password, :password_confirmation)
  end
end