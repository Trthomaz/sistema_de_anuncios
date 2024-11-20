"""empty message

Revision ID: 8bf99300e118
Revises: c4b1432e51b1
Create Date: 2024-11-20 13:33:45.584235

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '8bf99300e118'
down_revision = 'c4b1432e51b1'
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
    op.create_table('anuncios',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('anunciante', sa.Integer(), nullable=True),
    sa.Column('descricao', sa.Text(), nullable=True),
    sa.Column('telefone', sa.String(), nullable=True),
    sa.Column('local', sa.String(), nullable=True),
    sa.Column('categoria', sa.Integer(), nullable=True),
    sa.Column('tipo', sa.Integer(), nullable=True),
    sa.Column('nota', sa.Integer(), nullable=True),
    sa.Column('ativo', sa.Boolean(), nullable=True),
    sa.ForeignKeyConstraint(['anunciante'], ['perfis.id'], ),
    sa.ForeignKeyConstraint(['categoria'], ['categorias.id'], ),
    sa.ForeignKeyConstraint(['tipo'], ['tipos.id'], ),
    sa.PrimaryKeyConstraint('id')
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
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('mensagens')
    op.drop_table('conversas')
    op.drop_table('anuncios')
    op.drop_table('tipos')
    op.drop_table('perfis')
    op.drop_table('categorias')
    # ### end Alembic commands ###
