function deletar_construtor() {
    local pattern=$1
    while read -r file; do
        local classe=$(basename $file | sed "s/.java//g")
        local comando=""
        local encontrado=false
        local n="0"
        local linhas=""
        local eh_para_deletar=false
        while IFS= read -r linha; do
            n=$(($n + 1))
            if [[ "${linha}" = *"extends RepositorioBaseImpl"* ]]; then
                eh_para_deletar=true
            fi

            if [[ "${eh_para_deletar}" = "true" ]]; then
                if [[ "${linha}" = *"public ${classe}"* ]]; then
                    encontrado=true
                    linhas+="$(($n - 1))d;"
                fi
                if [[ "${encontrado}" = "true" ]]; then
                    linhas+="${n}d;"
                    if [[ "${linha}" = *"}"* ]]; then
                        encontrado=false
                    fi
                fi
            fi
        done <"$file"
        if [ -n "$linhas" ]; then
            eval "sed -i '${linhas}' ${file}"
        fi
    done < <(find ~+ -name "${pattern}")
}

function deletar_entity_manager() {
    local pattern=$1
    while read -r file; do
        local classe=$(basename $file | sed "s/.java//g")
        local comando=""
        local encontrado=false
        local n="0"
        local linhas=""
        local eh_para_deletar=false
        while IFS= read -r linha; do
            n=$(($n + 1))
            if [[ "${linha}" = *"public class ${classe} extends RepositorioBaseImpl"* ]]; then
                eh_para_deletar=true
            fi

            if [[ "${eh_para_deletar}" = "true" ]]; then
                if [[ "${linha}" = *"EntityManager entityManager;"* ]]; then
                    linhas+="$(($n - 1))d;"
                    linhas+="${n}d;"
                fi
            fi
        done <"$file"
        if [ -n "$linhas" ]; then
            eval "sed -i '${linhas}' ${file}"
        fi
    done < <(find ~+ -name "${pattern}")
}

git checkout .
git clean -fd
git pull

rm -rf ./pom.xml
find . -name "RepositorioBase.java" -exec rm -rf "{}" \;
find . -name "RepositorioBaseImpl.java" -exec rm -rf "{}" \;
find . -name "SrvbWfSsAutorizacaoApplication.java" -exec rm -rf "{}" \;
find . -name "OracleDSConfig.java" -exec rm -rf "{}" \;
find . -iname "*BoGenCrud*" -exec rm -rf "{}" \;
find . -iname "UtilsRestrictionsHibernate*" -exec rm -rf "{}" \;
find . -iname "Db2DSConfig*" -exec rm -rf "{}" \;


find . -iname "BuscarListaPorConsultaCustomizadaPaginadaAutomatica*" -exec rm -rf "{}" \;
find . -iname "DtoCoreQry*" -exec rm -rf "{}" \;
find . -iname "*DaoGen*" -exec rm -rf "{}" \;
find . -iname "DtoQry*" -exec rm -rf "{}" \;
find . -iname "BuscarRegistrosPorQueryMapParams*" -exec rm -rf "{}" \;
find . -iname "BuscarQuantTotalRegistros*" -exec rm -rf "{}" \;
find . -iname "SrvQ*" -exec rm -rf "{}" \;
find . -iname "SrvD*" -exec rm -rf "{}" \;
find . -iname "SrvUpdate*" -exec rm -rf "{}" \;
find . -iname "*SrvCrud*" -exec rm -rf "{}" \;
find . -iname "BuscaAutomaticaPropriedades*" -exec rm -rf "{}" \;
find . -iname "BuscarListaPorConsultaPaginadaAutomatica*" -exec rm -rf "{}" \;
find . -iname "BuscarPorFiltro*" -exec rm -rf "{}" \;
find . -iname "BuscarPorId*" -exec rm -rf "{}" \;
find . -iname "BuscarPorIdMaxIncremental*" -exec rm -rf "{}" \;


cat <<EOT >> ./pom.xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.4</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    <groupId>com.example</groupId>
    <artifactId>srvb-wf-ss-autorizacao</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>srvb-wf-ss-autorizacao</name>
    <description>Autorização</description>
    <properties>
        <java.version>21</java.version>
        <maven.compiler.source>21</maven.compiler.source>
        <maven.compiler.target>21</maven.compiler.target>
        <java.version>21</java.version>
    </properties>

    <repositories>
        <repository>
            <id>confluent</id>
            <url>https://packages.confluent.io/maven/</url>
            <releases>
                <enabled>true</enabled>
            </releases>
        </repository>
    </repositories>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-validation</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <scope>runtime</scope>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-jdbc</artifactId>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-configuration-processor</artifactId>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-webflux</artifactId>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.30</version>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>io.swagger</groupId>
            <artifactId>swagger-annotations</artifactId>
            <version>1.6.8</version>
        </dependency>
        <dependency>
            <groupId>javax</groupId>
            <artifactId>javaee-api</artifactId>
            <version>8.0.1</version>
        </dependency>
        <dependency>
            <groupId>org.apache.commons</groupId>
            <artifactId>commons-lang3</artifactId>
            <version>3.12.0</version>
        </dependency>
        <dependency>
            <groupId>org.jboss.resteasy</groupId>
            <artifactId>resteasy-client</artifactId>
            <version>3.0.19.Final</version>
        </dependency>
        <dependency>
            <groupId>commons-collections</groupId>
            <artifactId>commons-collections</artifactId>
            <version>3.2.1</version>
        </dependency>
        <dependency>
            <groupId>org.apache.commons</groupId>
            <artifactId>commons-collections4</artifactId>
            <version>4.4</version>
        </dependency>
        <dependency>
            <groupId>javax.xml.ws</groupId>
            <artifactId>jaxws-api</artifactId>
            <version>2.3.1</version>
        </dependency>
        <dependency>
            <groupId>io.swagger</groupId>
            <artifactId>swagger-jaxrs</artifactId>
            <version>1.5.16</version>
        </dependency>
<!--        <dependency>-->
<!--            <groupId>org.hibernate.orm</groupId>-->
<!--            <artifactId>hibernate-core</artifactId>-->
<!--            <version>6.6.0.Final</version>-->
<!--        </dependency>-->
        <dependency>
            <groupId>com.oracle.database.jdbc</groupId>
            <artifactId>ojdbc11</artifactId>
        </dependency>
        <dependency>
            <groupId>com.squareup.okhttp</groupId>
            <artifactId>okhttp</artifactId>
            <version>2.7.5</version>
        </dependency>
        <!-- https://mvnrepository.com/artifact/org.apache.axis/axis -->
        <dependency>
            <groupId>org.apache.axis</groupId>
            <artifactId>axis</artifactId>
            <version>1.4</version>
        </dependency>
        <!-- https://mvnrepository.com/artifact/org.json/json -->
        <dependency>
            <groupId>org.json</groupId>
            <artifactId>json</artifactId>
            <version>20230227</version>
        </dependency>
        <dependency>
            <groupId>com.google.code.gson</groupId>
            <artifactId>gson</artifactId>
            <version>2.8.2</version>
        </dependency>
        <dependency>
            <groupId>com.squareup.okhttp3</groupId>
            <artifactId>okhttp</artifactId>
            <version>3.14.2</version>
        </dependency>
        <dependency>
            <groupId>com.github.javafaker</groupId>
            <artifactId>javafaker</artifactId>
            <version>1.0.2</version>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <configuration>
                    <excludes>
                        <exclude>
                            <groupId>org.projectlombok</groupId>
                            <artifactId>lombok</artifactId>
                        </exclude>
                    </excludes>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.2.3</version>
                <configuration>
                    <argLine>--enable-preview</argLine>
                    <includes>
                        <include>**/*Teste.java</include>
                    </includes>
                    <excludes>
                        <exclude>**/BaseTest.java</exclude>
                        <exclude>**/TestsUtil.java</exclude>
                    </excludes>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <configuration>
                    <source>21</source>
                    <target>21</target>
                    <compilerArgs>--enable-preview</compilerArgs>
                </configuration>
            </plugin>
        </plugins>
        <finalName>autorizacao</finalName>
    </build>
    <profiles>
        <profile>
            <id>local</id>
            <properties>
                <activatedProperties>local</activatedProperties>
            </properties>
        </profile>
        <profile>
            <id>dev</id>
            <properties>
                <activatedProperties>dev</activatedProperties>
            </properties>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
        </profile>
        <profile>
            <id>homologacao</id>
            <properties>
                <activatedProperties>homologacao</activatedProperties>
            </properties>
        </profile>
        <profile>
            <id>producao</id>
            <properties>
                <activatedProperties>producao</activatedProperties>
            </properties>
        </profile>
    </profiles>
</project>
EOT

cat <<EOT >> ./src/main/java/srvbwfssautorizacao/SrvbWfSsAutorizacaoApplication.java
package srvbwfssautorizacao;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.annotation.PostConstruct;
import java.util.Arrays;
import java.util.TimeZone;

@SpringBootApplication
@Configuration
public class SrvbWfSsAutorizacaoApplication {

    public static void main(String[] args) {
        SpringApplication.run(SrvbWfSsAutorizacaoApplication.class, args);
    }

    @Bean
    public CommandLineRunner commandLineRunner(ApplicationContext ctx) {
        return _ -> {
            System.out.println("Let's inspect the beans provided by Spring Boot:");
            String[] beanNames = ctx.getBeanDefinitionNames();
            Arrays.sort(beanNames);
            for (String beanName : beanNames) {
                System.out.println(beanName);
            }

        };
    }

    @PostConstruct
    public void init() {
        TimeZone.setDefault(TimeZone.getTimeZone("GMT-4"));
    }

}
EOT

cat <<EOT >> ./src/main/java/br/com/sisgs/lib/util/core/anotacao/OracleDSConfig.java
package br.com.sisgs.lib.util.core.anotacao;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.boot.orm.jpa.EntityManagerFactoryBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.transaction.PlatformTransactionManager;

import javax.sql.DataSource;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

@Configuration
@EnableJpaRepositories(basePackages = "srvbwfssautorizacao.*", entityManagerFactoryRef = "oracleEntityManager", transactionManagerRef = "oracleTransactionManager")
public class OracleDSConfig {

    @Primary
    @Bean(name = "oracleDataSource")
    @ConfigurationProperties(prefix = "spring.oracle.datasource")
    public DataSource dataSource() {
        return DataSourceBuilder.create().build();
    }

    @Primary
    @Bean(name = "oracleEntityManager")
    public LocalContainerEntityManagerFactoryBean oracleEntityManagerFactory(EntityManagerFactoryBuilder builder,
                                                                             @Qualifier("oracleDataSource") DataSource dataSource) {
        Map<String, Object> properties = new HashMap<>();

        return builder.dataSource(dataSource)
                .properties(properties)
                .packages("srvbwfssautorizacao.*")
                .persistenceUnit("PuOraCassems").build();
    }

    @Bean(name = "oracleTransactionManager")
    @Primary
    public PlatformTransactionManager oracleTransactionManager(
            @Qualifier("oracleEntityManager") LocalContainerEntityManagerFactoryBean entityManagerFactoryBean) {
        return new JpaTransactionManager(Objects.requireNonNull(entityManagerFactoryBean.getObject()));
    }

}
EOT

cat <<EOT >> ./src/main/java/br/com/sisgs/lib/util/core/dao/QueryBuilderCustomizado.java
package srvbwfssautorizacao.br.com.sisgs.lib.util.core.dao;

import jakarta.persistence.EntityManager;
import lombok.EqualsAndHashCode;
import srvbwfssautorizacao.br.com.sisgs.lib.util.core.dto.DtoBetween;
import srvbwfssautorizacao.br.com.sisgs.lib.util.core.enums.EnumComp;
import srvbwfssautorizacao.br.com.sisgs.lib.util.core.enums.EnumTipoQuery;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class QueryBuilderCustomizado<T> {
    private final List<Parametro> parametros = new ArrayList<>();
    private final EntityManager em;
    private final StringBuilder query;
    private EnumTipoQuery tipoQuery;
    private boolean cache;

    protected QueryBuilderCustomizado(EntityManager em) {
        this.em = em;
        this.query = new StringBuilder();
    }

    public QueryBuilderCustomizado<T> tipoConsulta(EnumTipoQuery tipoQuery) {
        this.tipoQuery = tipoQuery;
        return this;
    }

    public QueryBuilderCustomizado<T> add(String query) {
        this.query.append(query);
        return this;
    }

    public QueryBuilderCustomizado<T> where1eq1() {
        this.query.append(" where 1=1");
        return this;
    }

    public QueryBuilderCustomizado<T> andNotNull(String s, EnumComp enumComp) {
        setarParametro(s, enumComp, null);
        return this;
    }

    public QueryBuilderCustomizado<T> andNotNull(String s, EnumComp enumComp, Integer valor) {
        setarParametro(new Parametro<>(s, enumComp, valor));
        return this;
    }

    public QueryBuilderCustomizado<T> andNotNull(String s, EnumComp enumComp, Collection<Integer> itens) {
        if (itens.isEmpty())
            return this;
        setarParametro(new Parametro<>(s, enumComp, itens));
        return this;
    }

    public QueryBuilderCustomizado<T> andNotNull(String s, EnumComp enumComp, String itens) {
        setarParametro(s, enumComp, itens);
        return this;
    }

    private void setarParametro(Parametro<Integer> parametro) {
        parametros.add(parametro);
        this.query.append(parametro);
    }

    private <P> void setarParametro(String s, EnumComp enumComp, P itens) {
        var parametro = new Parametro<>(s, enumComp, itens);
        parametros.add(parametro);
        this.query.append(parametro);
    }

    public QueryBuilderCustomizado<T> andNotNull(String s, EnumComp enumComp, BigDecimal valor) {
        setarParametro(s, enumComp, valor);
        return this;
    }

    public QueryBuilderCustomizado<T> cacheDesativar() {
        this.cache = false;
        return this;
    }

    //todo: verificar uma forma de retorno um valor generico sem warning igual o instancio faz
    public List<T> executar() {
        var q = em.createQuery(query.toString());
        for (var parametro : parametros) {
            q.setParameter(parametro.nome, parametro.valor == null ? parametro.valores : parametro.valor);
        }
        if (this.cache)
            q.setHint("org.hibernate.cacheable", true);
        return (List<T>) q.getResultList();
    }

    public T executarSingle() {
        var q = em.createQuery(query.toString());
        parametros.forEach(parametro -> q.setParameter(parametro.nome, parametro.valor == null ? parametro.valores : parametro.valor));
        if (this.cache)
            q.setHint("org.hibernate.cacheable", true);
        return (T) q.getSingleResult();
    }

    public QueryBuilderCustomizado andNotNull(String s, EnumComp enumComp, DtoBetween datas) {
        this.query.append(STR."\{s} between \{datas.getDataInicio()} and \{datas.getDataFim()} ");
        return this;
    }

    public QueryBuilderCustomizado<T> converterInicio() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public QueryBuilderCustomizado<T> converterFim() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public QueryBuilderCustomizado<T> desc(String s) {
        this.query.append(STR." order by \{s} desc ");
        return this;
    }

    public QueryBuilderCustomizado<T> asc(String s) {
        this.query.append(STR." order by \{s} ");
        return this;
    }

    @EqualsAndHashCode
    private static final class Parametro<R> {
        private final String s;
        private final EnumComp comparador;
        private final Collection<R> valores;
        private final R valor;
        private final String nome;

        private Parametro(String s, EnumComp comparador, Collection<R> valores) {
            this.s = s;
            this.comparador = comparador;
            this.valores = valores;
            this.valor = null;
            this.nome = s.replace(".", " ").replace(" ", "");
        }

        private Parametro(String s, EnumComp comparador, R valor) {
            this.s = s;
            this.comparador = comparador;
            this.valor = valor;
            this.valores = List.of();
            this.nome = s.replace(".", " ").replace(" ", "");
        }

        @Override
        public String toString() {
            return switch (comparador) {
                case MAIOR, NOT_IN -> "break";
                case MAIOR_IGUAL -> "break";
                case MENOR -> "break";
                case MENOR_IGUAL -> "break";
                case DIFERENTE -> "break";
                case IS_NULL -> "break";
                case IS_NOT_NULL -> "break";
                case BETWEEN -> "break";
                case IN -> STR." and \{s} in :\{nome}";
                case IGUAL -> STR." and \{s} = :\{nome}";
                case LIKE_CONTEM -> "break";
                case LIKE_INICIA_COM -> "break";
                case LIKE_TERMINA_COM -> "break";
                case LIKE_EXATAMENTE_IGUAL -> "break";
                case LIKE_CONTEM_SENSITIVE -> "break";
                case LIKE_INICIA_COM_SENSITIVE -> "break";
                case LIKE_TERMINA_COM_SENSITIVE -> "break";
                case LIKE_EXATAMENTE_IGUAL_SENSITIVE -> "break";
                default -> "adsfa";
            };
        }
    }
}
EOT

rm -rf src/main/resources/application.properties
cat <<EOT >> ./src/main/resources/application.properties
logging.level.web=TRACE
logging.level.org.springframework.web=TRACE
spring.profiles.active=@activatedProperties@
spring.datasource.driverClassName=oracle.jdbc.driver.OracleDriver
spring.jpa.hibernate.ddl-auto=none
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.OracleDialect
spring.jpa.database-platform=org.hibernate.dialect.Oracle Dialect
spring.main.allow-bean-definition-overriding=true
spring.jpa.show-sql=false

#hikariConfig
tempoMaximoDeVidaNoPoolEmMinutos=5
tempoParaLiberarPoolInativoEmMinutos=1
quantidadeMaxPools=100

server.port=8080
padraoTiss=4.00.01
idTabelaTiss=9
possuiTissQuatro=true
EOT

cat <<EOT >> ./src/main/resources/application-local.properties
logging.level.web=TRACE
logging.level.org.springframework.web=TRACE
spring.jpa.hibernate.ddl-auto=none
spring.main.allow-bean-definition-overriding=true

#hikariConfig
tempoMaximoDeVidaNoPoolEmMinutos=5
tempoParaLiberarPoolInativoEmMinutos=1
quantidadeMaxPools=100

server.port=8080
padraoTiss=4.00.01
idTabelaTiss=9
possuiTissQuatro=true
spring.devtools.add-properties=false
#jpa
spring.datasource.username=EDGAR.ASSIS
spring.datasource.password=cassems@22
spring.datasource.url=jdbc:oracle:thin:@172.16.32.32:1521/cdbhomol
spring.datasource.driverClassName=oracle.jdbc.driver.OracleDriver
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.OracleDialect
spring.jpa.database-platform=org.hibernate.dialect.OracleDialect
spring.jpa.show-sql=false
#ORACLE
spring.oracle.jpa.hibernate.ddl-auto=validate
spring.oracle.datasource.username=\${spring.datasource.username}
spring.oracle.datasource.password=\${spring.datasource.password}
spring.oracle.datasource.jdbc-url=\${spring.datasource.url}

#URL
SRV_PRESTADOR=http://privhmlsisgs.cassems.com.br/ptd/srvb-wf-ss-prestador/rest
SRV_BENEFICIARIO=http://privhmlsisgs.cassems.com.br/ben/srvb-wf-ss-beneficiario/rest/
#TISS
loginAgSaude=services.cconecte
senhaAgSaude=P@ssword
servicoSolicitacaoDeProcedimento=http://172.16.34.37/WebServicesTiss/NonAuthenticatedServiceHost/tissSolicitacaoProcedimentoV3_05_00.svc
servicoVerificadorDeElegibilidade=http://172.16.34.37/WebServicesTiss/NonAuthenticatedServiceHost/tissVerificaElegibilidadeV3_05_00.svc
servicoAutorizacao=http://privhmlsisgs.cassems.com.br/aut/srvb-wf-ss-autorizacao/rest
tissNode=http://172.16.106.52:3000
EOT

cat <<EOT >> ./src/main/java/br/com/sisgs/lib/util/core/dao/RepositorioBaseImpl.java
package br.com.sisgs.lib.util.core.dao;

import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;

import jakarta.persistence.EntityManager;
import jakarta.transaction.Transactional;
import java.lang.reflect.ParameterizedType;
import java.util.List;

@Repository
public class RepositorioBaseImpl<E> implements RepositorioBase<E> {

    @PersistenceContext(unitName = "PuOraCassems")
    protected EntityManager entityManager;

    public EntityManager getEm() {
        return entityManager;
    }

    public EntityManager getSession() {
        return entityManager;
    }


    @Transactional(rollbackOn = Exception.class)
    public E salvaOuAtualiza(E entidade) {
        entityManager.persist(entidade);
        return entidade;
    }

    @Transactional(rollbackOn = Exception.class)
    public E salvaOuAtualiza(E entidade, Object pk) {
        entityManager.persist(entidade);
        return entidade;
    }

    @Transactional(rollbackOn = Exception.class)
    public E salvaOuAtualiza(E entidade, Object pk, Object acao) {
        entityManager.persist(entidade);
        return entidade;
    }

    @Transactional(rollbackOn = Exception.class)
    public void salvaOuAtualiza(List<E> entidades) {
        entidades.forEach(this::salvaOuAtualiza);
    }

    @Transactional(rollbackOn = Exception.class)
    public Integer remove(E entidade) {
        entityManager.remove(entidade);
        return 1;
    }

    @Transactional(rollbackOn = Exception.class)
    public Integer remove(E entidade, Object pk) {
        entityManager.remove(entidade);
        return 1;
    }

    @Transactional(rollbackOn = Exception.class)
    public Integer remove(E entidade, Object pk, Object acao) {
        entityManager.remove(entidade);
        return 1;
    }

    @Transactional
    public E buscarPorId(Integer id) {
        var classe = obterClasseDaEntidade();
        var query = entityManager.createQuery("from " + classe.getSimpleName() + " where id = :id");
        query.setParameter("id", id);
        return (E) query.getSingleResult();
    }

    @Transactional
    public List<E> buscarTodos(Integer quantidadeDeRegistros) {
        var classe = obterClasseDaEntidade();
        var query = entityManager.createQuery(STR." from \{classe.getSimpleName()}");
        if (quantidadeDeRegistros != null || quantidadeDeRegistros != 0)
            query.setMaxResults(quantidadeDeRegistros);
        return (List<E>) query.getSingleResult();
    }   
    
    @Transactional
    public List<E> buscarTodos() {
        return buscarTodos(0);
    }

    @Transactional
    public Class<E> obterClasseDaEntidade() {
        return (Class<E>) ((ParameterizedType) getClass().getGenericSuperclass()).getActualTypeArguments()[0];
    }

    @Transactional(rollbackOn = Exception.class)
    public void atualizar(E entidade) {
        entityManager.merge(entidade);
    }

    public QueryBuilderCustomizado<E> getQry() {
        return new QueryBuilderCustomizado<>(entityManager);
    }

}
EOT

cat <<EOT >> ./src/main/java/br/com/sisgs/lib/util/core/dao/RepositorioBase.java
package br.com.sisgs.lib.util.core.dao;

import java.util.List;

public interface RepositorioBase<E> {
    E salvaOuAtualiza(E entidade);
    void salvaOuAtualiza(List<E> entidades);
    Integer remove(E entidade);
    Integer remove(E entidade, Object pk);
    Integer remove(E entidade, Object pk, Object acao);
    E buscarPorId(Integer id);
    void atualizar(E entidade);
}
EOT

cat <<EOT >> ./src/main/java/br/com/sisgs/lib/util/core/bo/BoGenCrud.java
package br.com.sisgs.lib.util.core.bo;

import br.com.sisgs.lib.util.core.excecao.ExBo;
import org.springframework.beans.factory.annotation.Autowired;

public class BoGenCrud<T> {
    @Autowired
    protected ExBo exBo;
}
EOT

cat <<EOT >> ./src/main/java/br/com/sisgs/lib/util/core/bo/IBoGenCrud.java
package br.com.sisgs.lib.util.core.bo;

public interface IBoGenCrud<T> {
}
EOT

rm -rf ./src/main/java/br/com/sisgs/lib/util/core/dao/DaoGenBase.java 

#trocar
find . -iname "DaoExecucaoEventos.java" -exec sed -i "/entityManeger.getDelegate\b/d" "{}" \;
find . -iname "DaoExecucaoEventos.java" -exec sed -i "s/sessionImpl.connection()/entityManeger.unwrap(Connection.class)/g" "{}" \;
find . -iname "Dao*.java" -exec sed -i "s/((SessionImpl) entityManager.getDelegate()).connection()/getEm().unwrap(Connection.class)/g" "{}" \;
find . -iname "Dao*.java" -exec sed -i "s/((SessionImpl) getEm().getDelegate()).connection()/getEm().unwrap(Connection.class)/g" "{}" \;
find . -iname "Dao*.java" -exec sed -i "s/((SessionImpl) this.getEm().getDelegate()).connection()/getEm().unwrap(Connection.class)/g" "{}" \;
find . -iname "Dao*.java" -exec sed -i "s/.setCacheable(false);/;/g" "{}" \;
find . -iname "*.java" -exec sed -i "s/DaoGen</RepositorioBaseImpl</g" "{}" \;
find . -iname "*.java" -exec sed -i "s/import br.com.sisgs.lib.util.core.dao.DaoGen;/import br.com.sisgs.lib.util.core.dao.RepositorioBaseImpl;/g" "{}" \;
find . -iname "*.java" -exec sed -i "s/@RequiredArgsConstructor(onConstructor = @__(@Autowired))/@RequiredArgsConstructor/g" "{}" \;
find . -iname "*.java" -exec sed -i "s/import javax.persistence./import jakarta.persistence./g" "{}" \;
find . -iname "*.java" -exec sed -i "s/@PersistenceContext(unitName = \"PuOraCassems\")/@PersistenceContext/g" "{}" \;
find . -iname "*.java" -exec sed -i "s/import javax.transaction.Transactional/import jakarta.transaction.Transactional/g" "{}" \;
find . -iname "*.java" -exec sed -i "s/@AnEmOraCassems//g" "{}" \;
find . -iname "DaoCaraterAtendimento.java" -exec sed -i "s/(String) resposta\[0\]/String.valueOf(resposta\[0\])/g" "{}" \;
find . -iname "DaoCaraterAtendimento.java" -exec sed -i "s/(String) resposta\[1\]/String.valueOf(resposta\[1\])/g" "{}" \;
find . -iname "DaoCaraterAtendimento.java" -exec sed -i "s/(String) objeto\[0\]/String.valueOf(objeto\[0\])/g" "{}" \;
find . -iname "DaoCaraterAtendimento.java" -exec sed -i "s/(String) objeto\[1\]/String.valueOf(objeto\[1\])/g" "{}" \;
find . -iname "DaoViaDeAcesso.java" -exec sed -i "s/acesso\[0\] != null ? SqlMontadorUtils.converterBigDecimalParaInteger((BigDecimal) acesso\[0\]) : null/(Integer) acesso\[0\]/g" "{}" \;
find . -iname "DaoViaDeAcesso.java" -exec sed -i "s/acesso\[1\] != null ? SqlMontadorUtils.converterBigDecimalParaInteger((BigDecimal) acesso\[1\]) : null/(Integer) acesso\[1\]/g" "{}" \;
find . -iname "DaoViaDeAcesso.java" -exec sed -i "s/acesso\[2\] != null ? (String) acesso\[2\] : null/(String) acesso\[2\]/g" "{}" \;
find . -iname "DaoViaDeAcesso.java" -exec sed -i "s/acesso\[3\] != null ? SqlMontadorUtils.converterBigDecimalParaInteger((BigDecimal) acesso\[3\]) : null/(Integer) acesso\[3\]/g" "{}" \;
find . -iname "DaoDtoJustificativaNegacao.java" -exec sed -i "s/SqlMontadorUtils.converterBigDecimalParaInteger((BigDecimal) item\[0\])/(Integer) item\[0\]/g" "{}" \;



#incluir referencias
# sed -i "3 i ${add[i]}" $file
find . -iname "DaoExecucaoEventos.java" -exec sed -i "3 i import java.sql.Connection;" "{}" \;
find . -iname "DaoDtoRetornoValorEventoValorFator.java" -exec sed -i "3 i import java.sql.Connection;" "{}" \;
find . -iname "DaoViAtendimentoAutorizacao.java" -exec sed -i "3 i import java.sql.Connection;" "{}" \;
find . -iname "DaoAtendimento.java" -exec sed -i "3 i import java.sql.Connection;" "{}" \;
find . -iname "DaoSamAutoriz.java" -exec sed -i "3 i import java.sql.Connection;" "{}" \;
find . -iname "DaoGeradorDeNumeroGuiaPrestador.java" -exec sed -i "3 i import java.sql.Connection;" "{}" \;
find . -iname "BuscadorDeProdutosOpmeTest.java" -exec sed -i "3 i import srvbwfssautorizacao.aplicacao.servicos.solicitacaoDeAutorizacao.BuscadorDeProdutosOpme;" "{}" \;
find . -iname "DaoSamAutorizaEventoSolicit.java" -exec sed -i "18 i \/\/;" "{}" \;
find . -iname "DaoIndicadorAcidente.java" -exec sed -i "21 i     @PersistenceContext" "{}" \;
find . -iname "DaoIndicadorAcidente.java" -exec sed -i "3 i import jakarta.persistence.PersistenceContext;" "{}" \;

#deletar linhas
find . -iname "*.java" -exec sed -i "/\import srvbwfssautorizacao.br.com.sisgs.lib.util.core.bo.IBoGenCrud\b/d" "{}" \;
find . -iname "*.java" -exec sed -i "/import srvbwfssautorizacao.br.com.sisgs.lib.util.core.bo.BoGenCrud/d" "{}" \;
find . -iname "Dao*.java" -exec sed -i "/super(em);/d" "{}" \;
find . -iname "Dao*.java" -exec sed -i "/StringBuilder consulta = getQry().getConsulta();/d" "{}" \;
find . -iname "Dao*.java" -exec sed -i "/getUpdate().atualizarTodosOsDados(true)/d" "{}" \;
find . -iname "Dao*.java" -exec sed -i "/getCache().evictAll()/d" "{}" \;
# find . -iname "Dao*.java" -exec sed -i "/EntityManager entityManager;/d" "{}" \;

# find . -iname "DaoMotivoInternacao.java" -exec sed -i "16d;17d;18d;19d;20d;21d" "{}" \;
# find . -iname "DaoMotivoInternacao.java" -exec sed -i "/public\ Dao[\s\S]*?\}/d" "{}" \;
# find . -iname "DaoMotivoInternacao.java" -exec grep -n -i 'public Dao' "{}" | cut -f1 -d:



# organizar arquivos
mv src/main/java/aplicacao/ src/main/java/srvbwfssautorizacao/
mv src/main/java/br/ src/main/java/srvbwfssautorizacao/
mv src/main/java/comum/ src/main/java/srvbwfssautorizacao/
mv src/main/java/execucaoevento/ src/main/java/srvbwfssautorizacao/
mv src/main/java/org/ src/main/java/srvbwfssautorizacao/
mv src/main/java/configuracao/ src/main/java/srvbwfssautorizacao/

find ./src/main -iname "*.java" -exec sed -i "s/package aplicacao/package srvbwfssautorizacao.aplicacao/g" "{}" \;
find ./src/main -iname "*.java" -exec sed -i "s/package br.com/package srvbwfssautorizacao.br.com/g" "{}" \;
find ./src/main -iname "*.java" -exec sed -i "s/package comum/package srvbwfssautorizacao.comum/g" "{}" \;
find ./src/main -iname "*.java" -exec sed -i "s/package execucaoevento/package srvbwfssautorizacao.execucaoevento/g" "{}" \;
find ./src/main -iname "*.java" -exec sed -i "s/package configuracao/package srvbwfssautorizacao.configuracao/g" "{}" \;

find ./src/ -iname "*.java" -exec sed -i "s/import aplicacao/import srvbwfssautorizacao.aplicacao/g" "{}" \;
find ./src/ -iname "*.java" -exec sed -i "s/import br.com/import srvbwfssautorizacao.br.com/g" "{}" \;
find ./src/ -iname "*.java" -exec sed -i "s/import static br.com/import static srvbwfssautorizacao.br.com/g" "{}" \;
find ./src/ -iname "*.java" -exec sed -i "s/import comum/import srvbwfssautorizacao.comum/g" "{}" \;
find ./src/ -iname "*.java" -exec sed -i "s/import execucaoevento/import srvbwfssautorizacao.execucaoevento/g" "{}" \;
find ./src/ -iname "*.java" -exec sed -i "s/import configuracao/import srvbwfssautorizacao.configuracao/g" "{}" \;

#deletar construtores
deletar_construtor "Dao*.java"
deletar_entity_manager "Dao*.java"