"""empty message

Revision ID: 55ded16d4c5a
Revises: f14fd50fbc66
Create Date: 2024-11-20 13:16:45.760835

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '55ded16d4c5a'
down_revision = 'f14fd50fbc66'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('categorias',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('categoria', sa.String(), nullable=True),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('categoria')
    )
    op.create_table('perfis',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('nome', sa.String(), nullable=True),
    sa.Column('curso', sa.String(), nullable=True),
    sa.Column('reputacao', sa.Float(), nullable=True),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_table('tipos',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('tipo', sa.String(), nullable=True),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('tipo')
    )
    op.create_table('conversas',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('interessado', sa.Integer(), nullable=True),
    sa.Column('anunciante', sa.Integer(), nullable=True),
    sa.Column('arquivada', sa.Boolean(), nullable=True),
    sa.ForeignKeyConstraint(['anunciante'], ['perfis.id'], ),
    sa.ForeignKeyConstraint(['interessado'], ['perfis.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    op.create_table('mensagens',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('user', sa.Integer(), nullable=True),
    sa.Column('txt', sa.Text(), nullable=True),
    sa.Column('date', sa.DateTime(), nullable=True),
    sa.Column('conversa', sa.Integer(), nullable=True),
    sa.ForeignKeyConstraint(['conversa'], ['conversas.id'], ),
    sa.ForeignKeyConstraint(['user'], ['perfis.id'], ),
    sa.PrimaryKeyConstraint('id')
    )
    op.drop_table('users')
    with op.batch_alter_table('anuncios', schema=None) as batch_op:
        batch_op.add_column(sa.Column('anunciante', sa.Integer(), nullable=True))
        batch_op.add_column(sa.Column('telefone', sa.String(), nullable=True))
        batch_op.add_column(sa.Column('local', sa.String(), nullable=True))
        batch_op.add_column(sa.Column('categoria', sa.Integer(), nullable=True))
        batch_op.add_column(sa.Column('tipo', sa.Integer(), nullable=True))
        batch_op.add_column(sa.Column('nota', sa.Integer(), nullable=True))
        batch_op.add_column(sa.Column('ativo', sa.Boolean(), nullable=True))
        batch_op.alter_column('descricao',
               existing_type=sa.VARCHAR(),
               type_=sa.Text(),
               existing_nullable=True)
        batch_op.create_foreign_key(None, 'tipos', ['tipo'], ['id'])
        batch_op.create_foreign_key(None, 'categorias', ['categoria'], ['id'])
        batch_op.create_foreign_key(None, 'perfis', ['anunciante'], ['id'])
        batch_op.drop_column('nome')

    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('anuncios', schema=None) as batch_op:
        batch_op.add_column(sa.Column('nome', sa.VARCHAR(), nullable=True))
        batch_op.drop_constraint(None, type_='foreignkey')
        batch_op.drop_constraint(None, type_='foreignkey')
        batch_op.drop_constraint(None, type_='foreignkey')
        batch_op.alter_column('descricao',
               existing_type=sa.Text(),
               type_=sa.VARCHAR(),
               existing_nullable=True)
        batch_op.drop_column('ativo')
        batch_op.drop_column('nota')
        batch_op.drop_column('tipo')
        batch_op.drop_column('categoria')
        batch_op.drop_column('local')
        batch_op.drop_column('telefone')
        batch_op.drop_column('anunciante')

    op.create_table('users',
    sa.Column('email', sa.VARCHAR(), nullable=False),
    sa.Column('name', sa.VARCHAR(), nullable=True),
    sa.Column('password', sa.VARCHAR(), nullable=True),
    sa.PrimaryKeyConstraint('email')
    )
    op.drop_table('mensagens')
    op.drop_table('conversas')
    op.drop_table('tipos')
    op.drop_table('perfis')
    op.drop_table('categorias')
    # ### end Alembic commands ###